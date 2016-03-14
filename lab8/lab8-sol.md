# Lab8-Sol

## List induction

```
for all l2 ∈ int list,
p(l) = length (list_add l l2) = max (length l) (length l2)
```

```
Base Case: l = []

p([]) = length (list_add [] l2) = max (length []) (length l2) = length l2
length (list_add [] l2) = length (l2)
```

```
Induction Case: p(l) -> p(x::l)

I.H) for all l2 ∈ int list,
length (list_add l l2) = max (length l) (length l2)

Want to show:
p(x::l) = length (list_add (x::l) l2) = max (length (x::l)) (length l2)

<<<<<<< HEAD
1) if length l1 <= length l2 
max (length (x::l)) (length l2) = length l2

length (list_add (x::l) l2) 
=======
1) if length l1 <= length l2
max (length (x::l)) (length l2) = length l2

length (list_add (x::l) l2)
>>>>>>> 2fd4e832454f888dbbc7c29b2b8efd4a0fc7acf0
= length ((x+x2)::(list_add l l2')) (by eval)
= length (x+x2) + length (list_add l l2') (by associative)
= 1 + max (length l) (length l2') (by I.H)
= 1 + length l2'    (l2' is rest elements without x2)
= length l2


2) if length l1 > length l2
max (length (x::l)) (length l2) = length (x::l) = length (x) + length (l) = 1 + length l

length (list_add (x::l) l2)
= length ((x+x2)::(list_add l l2')) (by eval)
= length (x+x2) + length (list_add l l2') (by associative)
= 1 + max (length l) (length l2') (by I.H)
= 1 + length l
```


## Polynomials

```
For all n ∈ polyExpr,

p(n)=deg n = deg (simplify n)
```

```
Base Case: p = X

p(X) = deg X = deg (simplify X) = deg (X) = 1

deg X = 1
```

```
<<<<<<< HEAD
Inductive Case: 
=======
Inductive Case:
>>>>>>> 2fd4e832454f888dbbc7c29b2b8efd4a0fc7acf0
p(X) -> p(Add (X, Int 1))
p(X) -> p(Mul (X, Int 1))

I.H) For all n ∈ polyExpr,
deg n = deg (simplify n)

Want to show:
1) p(Add (X, Int 1)) = deg (Add (X, Int 1)) = deg (simplify (Add (X, Int 1)))
= deg(Add(X, Int 1)) = max (deg X) (deg Int 1) = max (1) (0) = 1

deg (Add (x, Int 1)) = max (deg x) (deg Int 1) = max (1) (0) = 1

2) p(Mul (X, Int 1)) = deg (Mul (X, Int 1)) = deg (simplify (Mul (X, Int 1)))
= deg (Mul (X, Int 1)) = deg (X) + deg (Int 1) = 1 + 0 = 1

deg (Mul (X, Int 1)) = deg (X) + deg (Int 1) = 1 + 0 = 1
```


## Binomial Coefficients

<<<<<<< HEAD
'''
1. (r, d, nn)

2. let rec choose_loop (r, nn, d, k) = 
       if d > k 
       	  then (r, nn, d, k)
       else 
       	  choose_loop(((r*nn)/d), (nn-1), (d+1), k)
```

```
for all n, after each loop iteration, the state of the program satisfies,
p(k)= r = n!/k!*(n-k)!
=======
```
1. r, d, nn
```
```
2.
let ichoose (n:int) (k:int) =
    let rec choose_loop (r, nn, d) =
       if d <= k
          then (choose_loop (((r*nn)/d), (nn-1), (d+1)))
       else
       	  (r, nn, d)
    in let ans = (choose_loop (1, n, 1)) in match ans with
    | (r, nn, d) -> r
```

```
for all k: 0 <= k <= n
p(k) = r = n!/k!*(n-k)!
>>>>>>> 2fd4e832454f888dbbc7c29b2b8efd4a0fc7acf0
```

```
Base Case : k = 0
<<<<<<< HEAD
p(0)= r = n!/1*(n-1)!= n*(n-1)!/((n-1)!) = n
```

```
Inductive Case: p(n) -> p(n+1)
I.H) for all n, after each loop iteration, the state of the program satisfies,
 r = n!/d!*(n-d)!

Want to show:


=======
p(0)= r = n!/0!*(n-0)!= n!/(1*(n)!) = 1

ichoose n 0 = 1
```

```
Inductive Case: p(k) -> p(k+1)
I.H) for all k: 0 <= k <= n
r = n!/k!*(n-k)!

Want to show:
p(k+1) = r = n!/(k+1)!*(n-(k+1))!

ichoose n (k+1) = choose_loop (1, n, 1) = [(n*(n-1)*(n-2)*...*(n-(k+1)))]/(1*(1+1)*(2+1)*...*(k+1))   (by eval)
= [n!/(n-(k+1))!]/(k+1)! = n!/[(k+1)!*(n-(k+1))!] (by math)

```
>>>>>>> 2fd4e832454f888dbbc7c29b2b8efd4a0fc7acf0
