# 2. Induction on Lists

## lemma about tail_rev

```
for all l2 of type 'a list,
p(l) = tail_rev l l2 = reverse(l) @ l2
```

```
Base Case: l = []
p([]) = tail_rev [] l2 = reverse([]) @ l2 = [] @ l2 = l2

tail_rev [] l2 = l2
```

```
Inductive Case: p(l) -> p(x::l)

I.H) for all l2 of type 'a list,
tail_rev l l2 = reverse(l) @ l2

Want to show:
p(x::l) = tail_rev (x::l) l2 = reverse(x::l) @ l2
= (tail_rev l [x]) @ l2  (by eval)
= reverse(l) @ [x] @ l2  (by I.H)
= reverse(l) @ (x::l2)

tail_rev (x::l) l2
= tail_rev l (x::l2)  (by eval)
= reverse(l) @ (x::l2)   (by I.H)
```

## length

```
for all elements l of type int list,
p(l) = length l = length (reverse l).
```

```
Base Case: l = []
p([]) = length [] = length (reverse [])
= length ([]) (by eval)
= 0

length [] = 0
```

```
Inductive Case: p(l) -> p(x::l)

I.H) for all elements l of type int list,
length l = length (reverse l).

Want to show:
p(x::l) = length (x::l) = length (reverse (x::l))
= length(tail_rev (x::l) [])  (by eval)
= length((reverse l) @ (x::[]))   (by lemma about tail_rev)
= length(reverse l) + length([x])  (by associative)
= length(reverse l) + 1 (by eval)

length (x::l)
= 1 + length(l) (by eval)
 = 1 + length(reverse l) (by I.H)
```

## lemma about tsum

```
For all acc ∈ N,
p(l) =  tsum l acc = sumofallelements(l) + acc
```

```
Base Case: l = []
p([]) = tsum [] acc = sumofallelements([]) + acc = 0 + acc = acc
tsum [] acc = acc
```

```
Inductive Case: p(l) -> p(x::l)

I.H) For all acc ∈ N,
tsum l acc = sumofallelements(l) + acc

Want to show:
p(x::l) = tsum (x::l) acc = sumofallelements(x::l) + acc
= sumofallelements(l) + x + acc
= sumofallelements(l) + (x + acc)
= tsum l (x + acc) (by I.H)

tsum (x::l) acc
= tsum l (x + acc) (by eval)
```

## tail_sum

```
for all elements l of type int list,
p(l) = tail_sum l = tail_sum (reverse l)
```

```
Base Case: l = []
p([]) = tail_sum [] = tail_sum (reverse [])
= tail_sum ([]) (by eval)
= 0 (by eval)

tail_sum [] = 0 (by eval)
```

```
Inductive Case: p(l) -> p(x::l)

I.H) for all elements l of type int list,
tail_sum l = tail_sum (reverse l)

Want to show:
p(x::l) = tail_sum (x::l) = tail_sum (reverse (x::l))
= tail_sum (tail_rev l x::[])  (by eval)
= tail_sum (reverse l @ [x]) (by lemma about tail_rev)
= tail_sum (reverse l) + tail_sum ([x]) (by associative)
= x + tail_sum (reverse l) (by eval)

tail_sum (x::l)
= x + tail_sum l (by eval)
= x + tail_sum (reverse l) (by I.H)
```
