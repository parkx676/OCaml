type number = Int of int| Real of float 

let numInt1 = Int 2 
let numInt2 = Int 5
let numReal1 = Real 2.3
let numReal2 = Real 5.5

let to_int n = match n with
|Int i -> Some i
|_ -> None 

let to_float n = match n with
|Real x -> Some x
|_ -> None

let float_of_number n = match n with
|Int i -> float_of_int i
|Real r -> r 

let ( +> ) a b = match (a,b) with
|(Int i, Int i1) -> Int(i + i1)
|(Int r, Real r1) -> Real(float_of_int r +. r1)
|(Real e, Int e1) -> Real(e +. float_of_int e1)
|(Real t, Real t1) -> Real( t +. t1)

let ( *> ) a b = match (a, b) with
|(Int i, Int i1) -> Int (i*i1)
|(Int r, Real r1) -> Real(float_of_int r *. r1)
|(Real e, Int e1) -> Real (e *. float_of_int e1)
|(Real t, Real t1) -> Real (t *. t1)

