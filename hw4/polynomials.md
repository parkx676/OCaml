# 3. Polynomials

## lemma about list_deg
```
for all a of type polyList, if a.length > 1, then
list_deg (x::a) = list_deg ([x]) + list_deg a + 1
```

```
Base Case: a = [x]

list_deg (x::[x]) = list_deg ([x]) + list_deg [x] + 1
= (1 - 1) + (1 - 1) + 1 = 1

list_deg (x::[x]) = 2 - 1 = 1
```

```
Inductive Case: p(a) -> p(x::a)

I.H) list_deg (x::a) = list_deg ([x]) + list_deg a + 1

list_deg (x::(x::a)) = list_deg [x] + list_deg x::a + 1
= (1 - 1) + (list_deg x::a) + 1  (by eval)
= 0 + list_deg x::a + 1 (by math)
= list_deg ([x]) + list_deg a + 1 + 1  (by I.H)
= 0 + list_deg a + 2  (by eval)
= list_deg a + 2

list_deg (x::(x::a))
= list_deg ([x; x]::a)  (by associative)
= list_deg ([x; x]) + list_deg a + 1 (by I.H)
= (2 - 1) + list_deg a + 1  (by eval)
= 1 + list_deg a + 1  (by math)
= list_deg a + 2  (by math)

```

## lemma about to_poly

```
for all a of type polyList, if a.length > 0, then
deg(to_poly (x::a)) = deg (to_poly ([x])) + deg (to_poly a) + 1
```

```
Base Case: a = [x]

deg(to_poly (x::[])) = deg (to_poly ([x])) + deg (to_poly [x]) + 1
= deg (Add (Mul (Int x, Int 1), Int 0)) + deg (Add (Mul (Int x, Int 1), Int 0)) + 1  (by eval)
= (max (deg Mul(Int x, Int 1)) (deg Int 0)) + (max (deg Mul(Int x, Int 1)) (deg Int 0)) + 1  (by eval)
= (max ((deg Int x) + (deg Int 1)) (0)) + (max ((deg Int x) + (deg Int 1)) (0)) + 1  (by eval)
= (max (0 + 0) (0)) + (max (0 + 0) (0)) + 1  (by eval)
= 1 (by math)

deg(to_poly (x::[x]))
= deg(to_poly ([x; x]))
= deg (Add (Mul (Int x, Mul (X, Int 1)), Add (Mul (Int x, Int 1), Int 0)))  (by eval)
= 1  (by eval)
```

```
Inductive Case: p(a)->p(x::a)

I.H) deg(to_poly (x::a)) = deg (to_poly ([x])) + deg (to_poly a) + 1

Want to show:
deg(to_poly (x::(x::a))) = deg (to_poly ([x])) + deg (to_poly (x::a)) + 1
= deg (Add (Mul (Int x, Int 1), Int 0)) + deg (to_poly ([x])) + deg (to_poly a) + 1   (by I.H)
= deg (Add (Mul (Int x, Int 1), Int 0)) + deg (Add (Mul (Int x, Int 1), Int 0)) + deg (to_poly a) + 1  (by eval)
= (max (deg Mul(Int x, Int 1)) (deg Int 0)) + (max (deg Mul(Int x, Int 1)) (deg Int 0)) + deg (to_poly a) + 1  (by eval)
= (max ((deg Int x) + (deg Int 1)) (0)) + (max ((deg Int x) + (deg Int 1)) (0)) + deg (to_poly a) + 1   (by eval)
= (max (0 + 0) (0)) + (max (0 + 0) (0)) + deg (to_poly a) + 1   (by eval)
= 0 + 0 + deg (to_poly a) + 1  (by math)
= deg (to_poly a) + 1

deg(to_poly (x::(x::a)))
= deg(to_poly ((x::x)::a))  (by associative)
= deg (to_poly ([x; x])) + deg (to_poly a)  (by I.H)
= deg (Add (Mul (Int x, Mul (X, Int 1)), (Add (Mul(Int x, Int 1), Int 0)))) + deg (to_poly a)
= 1 + deg (to_poly a)  (by eval)
```

## deg (to_poly a) = list_deg a

```
for all a of type polyList
p(a) = deg (to_poly a) = list_deg a
```

```
Base Case: a = []

p([]) = deg (to_poly []) = list_deg [] = 0

deg (to_poly []) = deg (Int 0) = 0
```

```
Inductive Case: p(a) -> p(x::a)

I.H) for all a of type polyList
p(a) = deg (to_poly a) = list_deg a

Want to show:
p(x::a) = deg (to_poly (x::a)) = list_deg (x::a)
= list_deg([x]) + list_deg(a) + 1  (by lemma about list_deg)
= (1 - 1) + list_deg a + 1  (by eval)
= list_deg a + 1  (by math)

deg (to_poly (x::a))
= deg (to_poly ([x])) + deg (to_poly a) + 1  (by lemma about to_poly)
= deg (Add (Mul(Int x, Int 1), Int 0)) + deg (to_poly a) + 1  (by eval)
= [max (deg (Mul(Int x, Int 1))) (deg Int 0)] + deg (to_poly a) + 1 (by eval)
= [max (deg (Int x) + deg(Int 1)) (0)] + deg (to_poly a) + 1  (by eval)
= [max (0 + 0) (0)] + deg (to_poly a) + 1  (by eval)
= 0 + deg (to_poly a) + 1  (by eval)
= deg (to_poly a) + 1  (by math)
= list_deg a + 1 (by I.H)
```

##  list_deg

```
for all a2 of type int list,
p(a1, a2) = list_deg (list_add a1 a2) = deg (Add (to_poly a1, to_poly a2))
```

```
Base Case: a1 and a2 = []
p([], []) = list_deg (list_add [] []) = deg (Add (to_poly [], to_poly []))
= deg (Add (Int 0, Int 0))
= max (deg(Int 0)) (deg(Int 0))
= max (0) (0) = 0

list_deg (list_add [] []) = list_deg ([]) = 0
```

```
Inductive Case: p(a1, a2) -> p(x1::a1, x2::a2)

I.H) list_deg (list_add a1 a2) = deg Add(to_poly a1, to_poly a2)

Want to show:
p(x1::a1, x2::a2) =
list_deg (list_add (x1::a1) (x2::a2)) = deg Add(to_poly (x1::a1), to_poly (x2::a2))
= max (deg to_poly (x1::a1)) (deg to_poly (x2::a2))  (by eval)
= max (deg (to_poly [x1]) + deg (to_poly a1) + 1) (deg (to_poly [x2]) + deg (to_poly a2) + 1)  (by lemma about to_poly)
= max (deg ((Add (Mul(Int x1, Int 1) , Int 0))) + deg (to_poly a1) + 1) (deg ((Add (Mul(Int x2, Int 1) , Int 0))) + deg (to_poly a2) + 1)  (by eval)
= max ((max (deg (Mul (Int x1, Int 1))) (deg Int 0)) + deg (to_poly a1) + 1) ((max (deg (Mul (Int x2, Int 1))) (deg Int 0)) + deg (to_poly a2) + 1)  (by eval)
= max ((max (deg Int x1 + deg Int 1) (deg Int 0)) + deg (to_poly a1) + 1) ((max (deg Int x2 + deg Int 1) (deg Int 0)) + deg (to_poly a2) + 1)  (by eval)
= max (max (0 + 0) (0) + deg (to_poly a1) + 1) (max (0 + 0) 0 + deg (to_poly a2) + 1)  (by eval)
= max (0 + deg (to_poly a1) + 1) (0 + deg (to_poly a2) + 1)  (by eval)
= max (deg (to_poly a1) + 1) (deg (to_poly a2) + 1)  (by math)
= [max (deg (to_poly a1)) (deg (to_poly a2))] + 1  (by associative)

list_deg (list_add (x1::a1) (x2::a2))
= list_deg ((x1+x2)::list_add(a1, a2))  (by eval)
= list_deg ([x1+x2]) + list_deg(list_add(a1, a2)) + 1  (by lemma about list_deg)
= (1 - 1) + deg Add(to_poly a1, to_poly a2) + 1  (by eval)
= deg Add(to_poly a1, to_poly a2) + 1 (by math)
= [max (deg (to_poly a1)) (deg (to_poly a2))] + 1 (by eval)
```


## deg (compose p1 p2)

```
for all p2 of polyExpr,
p(l) = deg (compose l p2) = (deg l)*(deg p2)
```

```
Base Case:

1) l = X

p([]) = deg (compose X p2) = (deg X) * (deg p2)
= 1 * (deg p2) = deg p2

deg (compose X p2) = deg p2

2) l = Int 0

p(Int 0) = deg (compose Int 0 p2) = (deg Int 0) * (deg p2)
= 0 * (deg p2)
= 0

deg (compose Int 0 p2) = deg (Int 0) = 0
```

```
Inductive Case:

I.H)for all p2 of polyExpr,
deg (compose l p2) = (deg l)*(deg p2)

1) p(l) -> p(Add(e1, e2))

1-1) if (deg e1) >= (deg e2)
Want to show:
p(Add(e1, e2)) =
deg (compose (Add(e1, e2)) p2) = deg (Add(e1, e2))*(deg p2)
= (max (deg e1) (deg e2)) * (deg p2)  (by eval)
= (deg e1) * (deg p2)   (by eval)
= deg (compose e1 p2)  (by I.H)

deg (compose (Add(e1, e2)) p2)
= deg (Add (compose e1 p2, compose e2 p2))  (by eval)
= max (deg (compose e1 p2)) (deg (compose e2 p2))  (by eval)
= deg (compose e1 p2)  (by eval)

2-1) if (deg e1) < (deg e2)
Want to show:
p(Add(e1, e2)) =
deg (compose (Add(e1, e2)) p2) = deg (Add(e1, e2))*(deg p2)
= (max (deg e1) (deg e2)) * (deg p2)  (by eval)
= (deg e2) * (deg p2)   (by eval)
= deg (compose e2 p2)  (by I.H)

deg (compose (Add(e1, e2)) p2)
= deg (Add (compose e1 p2, compose e2 p2))  (by eval)
= max (deg (compose e1 p2)) (deg (compose e2 p2))  (by eval)
= deg (compose e2 p2)  (by eval)

2) p(l) -> p(Mul(e1, e2))
Want to show:
p(Mul(e1, e2)) = deg (compose Mul(e1, e2) p2) = (deg Mul(e1, e2))*(deg p2)
= ((deg e1) + (deg e2)) * (deg p2)  (by eval)
= [(deg e1) * (deg p2)] + [(deg e2) * (deg p2)]  (by math)
= deg (compose e1 p2) + deg (compose e2 p2)  (by I.H)


deg (compose Mul(e1, e2) p2)
= deg (Mul (compose e1 p2, compose e2 p2))   (by eval)
= (deg (compose e1 p2)) + (deg (compose e2 p2)) (by eval)
```

## deg (simplify p)

```
for all e of polyExpr,
p(e) = deg (simplify e) <= deg e
```

```
Base Case:
1) e = X
p(X) = deg (simplify X) <= deg X
<=>
deg (simplify X) <= 1  (by eval)
<=>
deg (X) <= 1 (by eval)
<=>
1 <= 1  (by eval)

true

2) e = Int 0
p(Int 0) = deg (simplify Int 0) <= deg Int 0
<=>
deg (simplify Int 0) <= 0
deg (Int 0) <= 0
0 <= 0

true
```

```
Inductive Case: for all e1, e2 of type polyExpr

I.H) for all e of polyExpr,
deg (simplify e) <= deg e

1) p(e) -> p(Add (e1, e2))
1-1) length of e1 >= length of e2
Want to show:
p(Add (e1, e2)) = deg (simplify (Add (e1, e2))) <= deg (Add (e1, e2))
<=>
deg (simplify (Add (e1, e2))) <= max (deg e1) (deg e2)  (by eval)
<=>
deg (simplify (Add (e1, e2))) <= deg e1  (by eval)
<=>
deg (simp_add (simplify e1, simplify e2)) <= deg e1  (by eval)
<=>
deg (Add (e1, e2)) <= deg e1  (by eval)
<=>
max (deg e1) (deg e2) <= deg e1  (by eval)
<=>
deg e1 <= deg e1  (by eval)

true


1-2) length of e1 < length of e2
Want to show:
p(Add (e1, e2)) = deg (simplify (Add (e1, e2))) <= deg (Add (e1, e2))
<=>
deg (simplify (Add (e1, e2))) <= max (deg e1) (deg e2)  (by eval)
<=>
deg (simplify (Add (e1, e2))) <= deg e2  (by eval)
<=>
deg (simp_add (simplify e1, simplify e2)) <= deg e2  (by eval)
<=>
deg (Add (e1, e2)) <= deg e2 (by eval)
<=>
max (deg e1) (deg e2) <= deg e2  (by eval)
<=>
deg e2 <= deg e2  (by eval)

true


2) p(e) -> p(Mul (X, Int 1))

2-1) length of e1 >= length of e2
Want to show:
p(Mul (e1, e2)) = deg (simplify (Mul (e1, e2))) <= deg (Mul (e1, e2))
<=>
deg (simplify (Mul (e1, e2))) <= (deg e1) + (deg e2)  (by eval)
<=>
deg (simp_mul (simplify e1, simplify e2) <= (deg e1) + (deg e2)  (by eval)
<=>
deg (Mul (e1, e2)) <= (deg e1) + (deg e2)  (by eval)
<=>
(deg e1) + (deg e2) <= (deg e1) + (deg e2)  (by eval)

true


2-2) length of e1 < length of e2
Want to show:
p(Mul (e1, e2)) = deg (simplify (Mul (e1, e2))) <= deg (Mul (e1, e2))
<=>
deg (simplify (Mul (e1, e2))) <= (deg e1) + (deg e2)  (by eval)
<=>
deg (simp_mul (simplify e1, simplify e2) <= (deg e1) + (deg e2)  (by eval)
<=>
deg (Mul (e1, e2)) <= (deg e1) + (deg e2)  (by eval)
<=>
(deg e1) + (deg e2) <= (deg e1) + (deg e2)  (by eval)

true
```
