# Input: integers n,m. Output: if n != 1 and m > 1 and gcd(n-1,m) = 1 then returns kernel of phi , else return false. 
ker_phi := function(n,m) 
	local F, a, b, Gamma_n, x, C, is_relatively_prime, mu, phi, ker_phi;

	# Construct gamma_n with generators a and b. 
	F := FreeGroup("a", "b");
	a := F.1;; b := F.2;;
	Gamma_n := F/[b*a^n*b*a^-1];
	a := Gamma_n.1;; b := Gamma_n.2;;

	# Construct cyclic group c of order m with generator x. 
	F := FreeGroup("x");
	x := F.1;;
	C := F/[x^m];
	x := C.1;;

	# If n != 1 and m > 1 and gcd(n-1,m) = 1 then returns kernel of phi , else return false. 
	is_relatively_prime := GcdInt(n-1,m) = 1;
	if is_relatively_prime and (not (n = 1)) and (m > 1) then 
		mu := -2/(n-1) mod m; 
		phi := GroupHomomorphismByImages(Gamma_n,C,[a,b],[x^mu,x]);
		ker_phi := Kernel(phi);
		return ker_phi;
	else
		return false;
	fi;
end; 

# Input: a group of fp type. Output: the abelianized group. 
abelianization := function(H)
	local iso, im_H, D, ab_H;
	iso := IsomorphismFpGroup(H); # GAP must deduce a finite presentation for G, otherwise it refuses to do the computation. 
	im_H := Image(iso);
	D := DerivedSubgroup(im_H); 
	ab_H := im_H/D; 
	return ab_H;
end;

# Input: abelian group. Output: rank of abelian group. 
rank := function(ab_H)
	local X, rk;
	X := GeneratorsOfGroup(ab_H);
	rk := Size(X);
	return rk;
end; 

# Input [n list] x [m list]. Output: nxm matrix with abelian ranks. 
compute_abelian_ranks := function(n_range, m_range)
	local n,m, H, rk, data, row;
	data := [];
	for n in n_range do	
		row := [];
		for m in m_range do 
			H := ker_phi(n,m);
			if not (H = false) then
				rk := rank(abelianization(H));
			else
				rk := -1; #If it is not possible to compute the abelianisation, then return -1 as a way of showing that. This is so all the outputs can be neatly stored in an integer matrix. 
			fi;
			Add(row, rk);
		od;
		Add(data, row);
	od;
	Display(data);
	return data;;
end; 	

# Input [n list] x m. Output list of list with structure description for H_{n,m} where n varies. 
compute_abelian_kernels := function(n_range, m)
	local data, n, row, H, ab_H, struct_ab_H;
	data := [];
	for n in n_range do
		row := [n];
		H := ker_phi(n,m);
		if not (H = false) then
			ab_H := abelianization(H);
			struct_ab_H := StructureDescription(ab_H);
		else
			struct_ab_H := "FAIL"; 
		fi;
		Add(row, struct_ab_H);
		Print(row, "\n");
		Add(data, row);
	od;
	return data;
end;