# Evaluations in LazyCaml

## take 3 (squares 3)

```
let rec take n lst = match (n,lst) with
  | (0, _) | (_, []) -> []
  | (n, (h :: t)) -> h :: (take (n-1) t)
```

```
take 3 (squares 3)

take 3 (9::(sqaures 4))

9::(take 2 (squares 4))

9::(take 2 (16::(squares 5)))

9::(16::(take 1 (sqaures 5)))

9::(16::(take 1 (25::(squares 6))))

9::(16::(25::(take 0 (sqaures 6))))

9::(16::(25::[]))

[9;16;25]
```

```
The expression evaluates to a normal form in a finite number of steps.
```

## fold_right (&&) (map ((<) 0) (squares 2)) true

```
fold_right (&&) (map ((<) 0) (squares 2)) true

fold_right (&&) (map ((<) 0) (4::(sqaures 2))) true

fold_right (&&) true::(map ((<) 0) (squares 3)) true

(&&) true (fold_right (&&) (map ((<) 0) (squares 3)) true)
.
.
.
```

```
It will never reach a normal form under lazy evaluation.
```

## fold_right (||) (map (fun n -> n mod 8 = 0) (factorials ())) false

```
fold_right (||) (map (fun n -> n mod 8 = 0) (factorials ())) false

fold_right (||) (map (fun n -> n mod 8 = 0) 1::(factorials())) false

fold_right (||) false::(map (fun n -> n mod 8 = 0) (factorials ())) false

(||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (factorials())) false)

(||) false (fold_right (||) (map (fun n -> n mod 8 = 0) 2::(factorials())) false)

(||) false (fold_right (||) false::(map (fun n -> n mod 8 = 0) (factorials())) false)

(||) false ((||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (factorials())) false))

(||) false ((||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (factorials())) false))

(||) false ((||) false (fold_right (||) (map (fun n -> n mod 8 = 0) 6::(factorials())) false))

(||) false ((||) false (fold_right (||) false::(map (fun n -> n mod 8 = 0) (factorials())) false))

(||) false ((||) false ((||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (factorials())) false)))

(||) false ((||) false ((||) false (fold_right (||) (map (fun n -> n mod 8 = 0) 24::(factorials())) false)))

(||) false ((||) false ((||) false (fold_right (||) true::(map (fun n -> n mod 8 = 0) (factorials())) false)))

(||) false ((||) false ((||) false ((||) true (fold_right (||) (map (fun n -> n mod 8 = 0) (factorials())) false))))

true
```

```
The expression evaluates to a normal form in a finite number of steps.
```

## take (sum_list (squares 1)) (factorials ())

```
let rec take n lst = match (n,lst) with
  | (0, _) | (_, []) -> []
  | (n, (h :: t)) -> h :: (take (n-1) t)
```

```
take (sum_list (squares 1)) (factorials ())

take (sum_list 1::(sqaures 2)) (factorials ())

take (sum_list 1::(sqaures 2)) (factorials ())

take 1+(sum_list (squares 2)) (factorials ())

take 1+(sum_list (squares 2)) 1::(factorials())
.
.
.
```

```
It will never reach a normal form under lazy evaluation.
```
