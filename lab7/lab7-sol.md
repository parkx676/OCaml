Binomial Coefficients

1.P(n)=if k < n then choose n k <=> n!/((n-k)! * k!)

2.Base Case
P(2)= if k < 2 then choose 2 k <=> 2!/((2-k)! * k!)
then k = 2.

choose 2 1 <=> 2!/((2-1)! * 1!) <=> 2
if (2=1) || (1 = 0) then 1 else ((choose (2-1) (1-1))*2)/1 <=> ((choose 1 0) * 2)/1 <=> 1*2/1 <=> 2


3.Inductive Case
n=x+1
want to show :P(x+1)=if k < x+1 then choose (x+1) k <=> (x+1)!/(((x+1)-k)! * k!).
Assume k < x+1.
Therefore, we must show choose (x+1) k <=> (x+1)!/(((x+1)-k)! * k!).

choose (x+1) k <=> (x+1)!/(((x+1)-k)! * k!)
if (x+1 = k) || (k = 0)  then 1 else ((choose x (k-1))*(x+1))/k <=>
 (x+1)!/(((x+1)-k)! * k!)

Suppose k != 0, we don't have to show k=0

Suppose x+1 = k
 1 <=> k!/((k-k)! * k!) <=> 1

Suppose x+1 != k and k > 0
((choose x (k-1))*(x+1))/k <=> (x+1)!/(((x+1)-k)! * k!)
(x!/((x-(k-1))! * (k-1)!))(x+1)/k <=> (x+1)!/(((x+1)-k)! * k!)
((x+1)!/((x-k+1)! * (k-1)!)/k <=> (x+1)!/(((x+1)-k)! * k!)
((x+1)!/((x-k+1)! * (k-1)! * k) <=> (x+1)!/(((x+1)-k)! * k!)
((x+1)!/((x-k+1)! * k!) <=> (x+1)!/(((x+1)-k)! * k!)
(x+1)!/(((x+1)-k)! * k)! <=> (x+1)!/(((x+1)-k)! * k!)



Structured Arithmetic

1. For all x ∈ nat, P(x) if
P(Zero) and ∀x, P(x) ⇒ P(Succ x)
Let’s prove: ∀m ∈ nat:
∀n∈nat: (to_int m) > (to_int n) ⇒ to_int (minus_nat m n) = (to_int m) - (to_int n)


2.Base Case: m = Zero

(to_int Zero) > (to_int n) => False

to_int (minus_nat Zero n) = (to_int Zero) - (to_int n) <=> invalid_arg "minus_nat not a natrual number!"

3.Inductive Case: m = Succ m
want to show :

I.H: (to_int (Succ m)) > (to_int (Succ n)) ⇒ to_int (minus_nat (Succ m) n) <=>
to_int Succ (minus_nat m n) <=> 1+ (to_int(minus_nat m n)) <=> 1 + ((to_int m) - (to_int n)) <=> (to_int Succ m) - (to_int n)


Structured Comparisons

1. For all x ∈ nat, P(x) if
P(Zero) and ∀x, P(x) ⇒ P(Succ x)
Let’s prove: ∀m ∈ nat:
∀n∈nat: (to_int m) = (to_int n) ⇔ eq_nat m n

2. Base Case: m = Zero, n = Zero

(to_int Zero) = (to_int Zero) <=> True
eq_nat Zero Zero <=> True

3. Inductive Case

I.H: (to_int (Succ m)) = (to_int (Succ n)) ⇔ eq_nat (Succ m) (Succ n) <=>
(eq_nat m n)

(to_int(Succ m)) = (to_int (Succ n)) <=> 1+ (to_int m) = 1 + (to_int n) <=> (to_int m) = (to_int n) <=> True
