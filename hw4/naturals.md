# 1. Induction on integers and `nat`

## power
```
for all n ∈ ℕ, for all x ∈ float,
p(n) = power x n = x^n
```

```
Base Case: n = 0

all x ∈ float, p(0) = power x 0 = x^0 = 1.0
<=> power x 0 = 1.0
```

```
Inductive Case: for all n ∈ ℕ, p(n) -> p(n+1)

I.H) all x ∈ float, power x n = x^n

Want to show:
for all n ∈ ℕ, for all x ∈ float, power x (n+1) = x^(n+1)

for all n ∈ ℕ, for all x ∈ float, p(n+1) = power x (n+1)
= x *. (power x n)  (by func. eval.)
= x *. x^n (by I.H)
= x^(n+1)
```

## pow_nat
```
for all n ∈ nat, for all x ∈ float,
p(n) = power x (to_int n) = pow_nat x n
```

```
Base Case: n = Zero
for all x ∈ float, p(Zero) = power x (to_int Zero) = pow_nat x Zero
power x (to_int Zero) = power x 0 = 1.0 (by power function eval)
pow_nat x Zero = 1.0
```

```
Inductive Case: for all n ∈ nat, p(n) -> p(Succ n)

I.H) for all n ∈ nat, for all x ∈ float, power x (to_int n) = pow_nat x n

Want to show:
for all n ∈ nat, for all x ∈ float,
power x (to_int (Succ n))
= pow_nat x (Succ n)
= x *. pow_nat x n


power x (to_int (Succ n))
= power x (1 + (to_int n)) (by to_int func. eval.)
= x *. (power x (to_int n)) (by power func. eval.)
=x *. pow_nat x n (by I.H)
```

## less_nat
```
for all m ∈ nat, for all n ∈ nat,
p(n) = less_nat m n <=> (to_int m) < (to_int n)
```

```
Base Case: n = Zero
for all m ∈ nat,
p(Zero) = less_nat m Zero <=> (to_int m) < (to_int Zero) = (to_int m) < 0 = false

less_nat m Zero = false
```

```
Inductive Case: p(n) -> p(Succ n)

I.H) for all m ∈ nat, for all n ∈ nat, less_nat m n <=> (to_int m) < (to_int n)

Want to show:
for all m ∈ nat, for all n ∈ nat,
p(Succ n) = less_nat m (Succ n) <=> (to_int m) < (to_int (Succ n))
= (to_int m) < 1 + (to_int n)
<=>
1) if m = n or m < n - 1 then true

2) if m >= n - 1 then false


less_nat m (Succ n)

1) if m = n or m < n - 1 then true

2) if m>= n - 1 then
= less_nat m n = false
```
