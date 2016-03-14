(* OCaml file for lab 1.
   Fix the errors in this file.  *)

let zero = (-2 + 2)

let fn x = x
let begining s = s.[zero]
let len num = String.length num
  
let mult x y = x * y

let or3 a b c = a || b || c

let helloworld = "hello" ^ "world"

let ending s t = let last = len s - 1 in String.sub s (last - t) t  

(*let c = beginning ""*)
	       
let () = print_string (ending "Looks like we made it!\n" 9)
  
(* Writing new Ocaml Functions *)

let scale  a  (b , c ) = (a*.b, a*.c)

let length (a, b) = sqrt(a*.a +. b*.b)

let unit_vector (a, b) = if sqrt(a*.a +. b*.b) =  1. then true else false
