# Thesis code

Here are the code snippets that was discussed Chapter 12 and the Appendix of my PhD thesis "A toolbox for left-orders of low complexity" available at: https://arxiv.org/pdf/2512.07035.

This package does GAP computations for the family of groups $$\Gamma_n = \langle a,b \mid ba^nb = a \rangle$$ discovered in Navas' paper *A remarkable family of left orderable groups: central extensions of Hecke groups*, which can be found here: https://arxiv.org/abs/0909.4994v2. This code helped conjecture then prove the existence of infinite families of groups with positive cones of rank $k$, for every $k \geq 3$ giving a full answer to the main question of Navas' paper. The results of these computations were also used construct positive cones with finite generating set for groups of the form $F_{2n}\times \mathbb{Z}$, extending a [result](https://arxiv.org/abs/1709.02348) of Malicet, Mann, Rivas, and Triestino (2019). (The research paper publishing this result is in writing.)

## ker_phi.g

The numerical experiment is set up as follows. Take the kernel equation
$\varphi(ba^nba^{-1}) \equiv 2\varphi(b) + (n-1)\varphi(a) \equiv 0 \mod m, \quad \varphi(b) = 1$
which essentially becomes 
$$(n-1)\mu \equiv -2 \mod m, \quad \mu := \varphi(a)$$
and, when it is possible, find a solution for $\mu$. From modular arithmetic, we know there always exists a solution when $\gcd(n-1,m) = 1$ since it is possible to compute $\frac{1}{n-1}$, and, in particular, $\frac{-2}{n-1}$.

We use GAP to compute the kernel $\ker \varphi$ for fixed $n,m$. It is not necessarily easy to deduce a priori the rank of a positive cone for this subgroup, but we can use the following fact to get a lower bound on the rank of the positive cone of $\ker \varphi$. 

Here's an example prompt to obtain the abelian rank of `ker_phi(n,m)`:

```
gap> n := 2;; m :=3 ;;
gap> H := ker_phi(n,m);
Group(<fp, no generators known>)
gap> AbH := abelianization(H); 
Group([ f1*f2*f3^-1, f3, f2^-1*f3 ])
gap> rank(AbH);
3
```

We can also make tables varying `n` and `m`. 

```
gap> n_range := [1..20];; m_range := [1..10];;
gap> data := compute_abelian_ranks(n_range, m_range);; 
```

Another straightforward-but-informative computation we can do is to probe what the structure of these abelianised kernels look like. Using the `compute_abelian_kernels` function, we may view what the abelian kernels for fixed `m`.  For example, this is how we would get the data for `m=3`. 

```
gap> n_range := [1..20];; m :=3;;
gap> data := compute_abelian_kernels(n_range, 3);; 
```
## normalize.g
Computes normal forms for `n=2`. 

An example use case normalising $w = b^{-1} a b^3$ in $n=2$ would be the following. 

```
gap> w := b^-1*a*b^3;;
gap> normalize(w);
a^2*b^4
```

If one wishes to verify an entire list at once, such as the generating set $Y$ of Section 12.4 of my thesis for the proof of Lemma 12.4.2.1,
then they can use the following prompt. 

```
gap> Y := [ a*b^2, b^-1*a*b^3, b^-2*a*b^4, b^-3*a*b^5, b^-4*a, b^-5*a*b, b^6 ];;
gap> Apply(Y, y -> normalize(y));
gap> Y; 
[ a*b^2, a^2*b^4, a*(a*b)^2*b^4, a*(a*b)^3*b^5, a*(a*b)^4, a*(a*b)^5*b, b^6 ]
gap> psi_Y := [x, y*x*z^-1, x^-1*y*x*z^-1, x^-1*y^-1*x^-1*y*x,x^-1*y^-1*z^2 ,x^-1*y^-1*x*z^2, y^-1*x^-1*y*x*z^-1];;
gap> Apply(psi_Y, y -> normalize(y));
gap> psi_Y;
[ a*b^2, a^2*b^4, a*(a*b)^2*b^4, a*(a*b)^3*b^5, a*(a*b)^4, a*(a*b)^5*b, b^6 ]
gap> Y = psi_Y;
true
```

## Acknowledgement
This project was done as part of my PhD research, which couldn't have happened without the guidance of my supervisor [Yago Antolín](https://sites.google.com/site/yagoanpi/). 
