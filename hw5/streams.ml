(* data type to represent an infinite data object in a "lazy" fashion *)
type 'a stream = Cons of 'a * (unit -> 'a stream)

(* Some utility functions for streams *)
let hd (Cons(h,t)) = h
let tl (Cons(h,t)) = t ()

let rec take_s n s = match (n,s) with
| (0,_) -> []
| (_,Cons(h,t)) -> h::(take_s (n-1) (t ()))

let rec map_s f (Cons(h,t)) = Cons(f h, fun () -> map_s f (t ()))

let rec merge s1 s2 = Cons(hd s1, fun () -> Cons(hd s2, fun () -> merge (tl s1) (tl s2)))

let rec filter_s p (Cons(h,t)) =
  if (p h) then Cons(h, fun () -> filter_s p (t ()))
  else filter_s p (t ())

let double s = merge s s

(* Some streams we have seen in lecture *)
let rec nats n = Cons(n, fun () -> nats (n+1))
let fibs = let rec fib_help f0 f1 = Cons(f0, fun () -> fib_help f1 (f0+f1)) in fib_help 0 1
let factorials = let rec fact_help n a = Cons(n*a, fun () -> fact_help (n+1) (n*a)) in fact_help 1 1

(* one more helpful function *)
let rec gcd a b =
  if a=0 then b
  else if b < a then gcd b a
  else gcd (b mod a) a

(* Your solutions for problem 3 go here: *)

(* pytrips *)
let rec natpairs (n1, n2) = Cons((n1, n2), fun () -> if  n2 = 0  then natpairs(0, n1 + 1) else natpairs(n1+1, n2-1))

let py_triple (n1, n2) = (n1, n2, int_of_float(sqrt(float_of_int((n1*n1) + (n2*n2)))))

let py_check (n1, n2, n3) = if (n1 < n2) && ((gcd n1 n2) = 1) && (int_of_float(sqrt(float_of_int((n1*n1) + (n2*n2)))) = n3) && (float_of_int(n3) = (sqrt(float_of_int((n1*n1) + (n2*n2))))) then true else false

let pytrips =  map_s (fun x -> py_triple x) (filter_s (fun x -> py_check(py_triple (x))) (natpairs(1, 1)))


(* palindrome generator *)
let pal_check s = let rec p_check i1 i2 = match (i1, i2) with
| (-1, _) -> true
| (i1, i2) -> if Char.lowercase(s.[i1]) = Char.lowercase(s.[i2]) then p_check (i1 - 1) (i2 + 1) else false
in p_check ((String.length(s) / 2) - 1) (if (String.length(s) mod 2) = 0 then ((String.length(s) / 2)) else ((String.length(s) / 2) + 1))


let kleene_star lst =
  let rec kleene lst lst2 r org = match (lst,lst2,r) with
    | ((h1::t1), (h2::t2), r) -> if r = 0 then Cons(h1, fun () -> (kleene t1 lst2 r org)) else (if (r mod (List.length org) = 0) then (Cons(h2^h1, fun () -> (kleene t1 (lst2@[h2^h1]) r org))) else (Cons(h2^h1, fun () -> (kleene t1 (lst2@[h2^h1]) r org))))
    | ([], h2::t2, r) -> if r = 0 then kleene org lst2 (r+1) org else (if (r mod (List.length org) = 0) then kleene org t2 (r+1) org else kleene org t2 (r+1) org)
    | (h1::t1, [], r) -> Cons(h1, fun () -> kleene t1 lst2 r org)
    | _ -> invalid_arg "Invalid arguments"
  in kleene (""::lst) lst 0 lst

let palindromes lst = filter_s (fun x -> pal_check x) (kleene_star lst)
