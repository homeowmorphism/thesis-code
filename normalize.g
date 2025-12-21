# Set up the environment for freely reduced words. 
F := FreeGroup("a", "b", "delta");
a := F.1;; b := F.2;; delta := F.3; 
n := 2;

# word in {a,a^-1, b, b^-1,delta, delta^-1} -> normalized word. 
normalize := function(w)
	local len_syl, last_syl_num, last_syl_pow, u, delta_pow, lw, norm_w;
	len_syl := NumberSyllables(w);
	if len_syl = 0 then 
		return w;
	else 
		last_syl_num := GeneratorSyllable(w, len_syl);
		last_syl_pow := ExponentSyllable(w, len_syl);
		if last_syl_num = 3 then 
			u := Subword(w, 1, len_syl-1);
			delta_pow := last_syl_pow;
		else 
			u := w;
			delta_pow := 0;
		fi;
		lw := [u, delta_pow]; 

		while not is_normal_list(lw) do
			lw := replace_inverses(lw);
			lw := apply_relation(lw); 
			lw := collect_deltas(lw); 
		od;
	fi; 
	u := lw[1];
	delta_pow := lw[2];
	norm_w := u*delta^delta_pow;
	return norm_w;
end; 

# [u, delta_pow] -> [u, delta_pow]
replace_inverses := function(lw)
	local lu, delta_pow, len_syl, new_u, new_delta_pow, i, gen, pow, u, abs_pow, syl;
	u := lw[1];
	delta_pow := lw[2];
	len_syl := NumberSyllables(u); 

	new_u := a^0; 
	new_delta_pow := delta_pow;

	for i in [1..len_syl] do
		gen := GeneratorSyllable(u, i);
		pow := ExponentSyllable(u, i);

		if gen = 1 then
			if pow < 0 then 
				abs_pow := -pow; 
				syl := (a^n)^abs_pow;
				new_delta_pow := new_delta_pow - abs_pow; 
			else
				syl := a^pow;
			fi;

		elif gen = 2 then 
			if pow < 0 then 
				abs_pow := -pow; 
				syl := (a^n*b*a^n)^abs_pow;
				new_delta_pow := new_delta_pow - abs_pow; 
			else
				syl := b^pow;
			fi;
		else 
			Error("Generator is not a or b in replace_inverses.");
		fi;
		new_u := new_u*syl; 
	od; 
	return [new_u, new_delta_pow];
end;

# [u, delta_pow] -> [u, delta_pow]
apply_relation := function(lw)
	local u, delta_pow, new_u, new_delta_pow;
	u := lw[1];
	delta_pow := lw[2];
	new_u := u;
	new_delta_pow := delta_pow; 

	while not(SubstitutedWord(new_u, b*a^n*b, 1, a) = fail) do
		new_u := SubstitutedWord(new_u, b*a^n*b, 1, a);
	od;
	return [new_u, new_delta_pow];
end;

# [u, delta_pow] -> [u, delta_pow]
collect_deltas := function(lw)
	local u, delta_pow, len_syl, new_u, new_delta_pow, i, gen, pow, syl, factor;
	u := lw[1];
	delta_pow := lw[2];
	len_syl := NumberSyllables(u); 

	new_u := a^0; 
	new_delta_pow := delta_pow;

	for i in [1..len_syl] do
		gen := GeneratorSyllable(u, i);
		pow := ExponentSyllable(u, i);

		if gen = 1 then 
			if pow > n then 
				factor := Int(pow / (n+1));
				new_delta_pow := new_delta_pow + factor;
				pow := pow - (factor * (n+1)); 
			fi;
			syl := a^pow; 

		elif gen = 2 then 
			syl := b^pow; 

		else
			Error("Generator is not a or b in collect_deltas.");
		fi; 
		new_u := new_u*syl;
	od;
	return [new_u, new_delta_pow];
end; 

# word in {a,a^-1, b, b^-1,delta, delta^-1} -> boolean
is_normal := function(w)
	local len_syl, last_syl_num, delta_pow, u, lw;
	len_syl := NumberSyllables(w);
	if len_syl = 0 then 
		return true;
	else 
		last_syl_num := GeneratorSyllable(w, len_syl);
		if last_syl_num = 3 then 
			delta_pow := ExponentSyllable(w, len_syl);
			u := SubSyllables(w, 1, len_syl-1); 
			lw := [u, delta_pow];
			return is_normal_list(lw);
		else 
			u := w;
			lw := [u, 0];
			return is_normal_list(lw);
		fi; 
	fi; 
end;

# [u, delta_pow] -> boolean
is_normal_list := function(lw)
	local u, len_syl, i, gen, pow;
	u := lw[1];
	len_syl := NumberSyllables(u); 
	for i in [1..len_syl] do
		gen := GeneratorSyllable(u, i);
		pow := ExponentSyllable(u, i);

		# check for word positivity
		if pow < 0 then 
			return false;

		# check that the deltas are collected
		elif gen = 3 and not(i = len_syl) then 
			return false;

		# check if b*a^n*b -> a has been done. 
		elif gen = 1 and pow > n-1 then  
			if not(i = 1) and not(i = len_syl) then 
				#Print("flagged");
				return false;
			fi; 
		fi; 
	od;
	return true;
end; 
