# 4. Loops

## lsearch

```
1) What is the state maintained by this function?
  i and fi
```

```
2)

let flsearch (f: int->int) (n:int) =
  let rec helper i fi n=
    if (i <= n && fi <= 0)
      then
        (helper (i+1) (f i) n)
      else
        i
  in helper 0 (f 0) n
```

### lemma about helper

```
for all i of int, for all fi of int,
if i' = helper i fi n then i' = i + (n + 1)
```

```
Base Case: n = 0
for all i of int, for all fi of int,
if i' = helper i fi 0 then i'= i + (0 + 1) = i + 1

helper i fi 0 = helper i+1 (f i) 0 = i + 1
```

```
Inductive Case: p(n) -> p(n+1)

I.H) for all i of int, for all fi of int,
if i' = helper i fi n then i' = i + (n + 1)

Want to show:
p(n+1) = if i' = helper i fi (n + 1) then i' = i + ((n + 1) + 1)
<=>
i' = i + (n + 1) + 1
<=>
i' = i + n + 2


helper i fi (n + 1)
= helper i+1 (f i) (n + 1) then i'
= (i + 1) + n + 1
= i + n + 2
```

### 1) For all f, for all n, if (f n) > 0 then f (lsearch f n) > 0.

```
(* Precondition: (f (i+1)) >= (f i) for all i < n, f(0) < 0 and f(n) > 0 *)

For all f, if (f n) > 0 then f (lsearch f n) > 0.
```

```
Base Case: n = 1

if (f 1) > 0 then f (lsearch f 1) > 0

(f 1) > 0

f (lsearch f 1) > 0
<=>
f (1) > 0  (by eval)
```

```
Inductive Case: p(i) -> p(i+1)

(f (i+1)) > 0

f (flsearch f (i+1)) > 0
f (i + 2) > 0 (by precondition)
```


### 2) For all f, if (f 0) < 0 then for all n, i < (lsearch f n) ⇒ (f i) < 0.

```
For all f,
if (f 0) < 0 then for all n, i < (lsearch f n) ⇒ (f i) < 0.
```

```
Base Case: n = 0

For all f,
if (f 0) < 0
<=> true (by precondition)

then for all n,
i < lsearch f 0
<=>
i < i + 1  (by eval)
<=>
true

thus (f i) < 0 is true
```

```
Inductive Case: p(i) -> p(i+1)

For all f,
if (f 0) < 0
<=> true (by precondition)

then for all n,
i < lsearch f (i+1)
<=>
i < (i+1) + 1  (by lemma)
<=>
i < i + 2
<=>
true

thus f(i+1) < 0 is also true.
```
---
**TA COMMENT(hoppernj)**: 
+ state: 2/2
+ loop: 1.5/2 (does not correctly advance fi)
+ first proof: 1.5/3 (does not establish inductive step)
+ second proof: 1/3 (lemma is false)

Score: 5/10
---
