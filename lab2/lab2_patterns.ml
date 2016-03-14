(* Pattern matching examples: try to predict what the result of each expression below will be.
   You can use utop to check. *)

(* tuples *)      
let (a,b) = (3,4) in a*b   (* int= 12 *)
let c,d = 1,2 (* val c : int = 1, val d : int = 2 *)

(* list patterns *)	      
let (h::t) = [1;2;3] (*val h : int = 1 , val t : int list = [2;3] *)
let (x::y::z) = [1] (*Not matched *)
let (_::rest) = [1;2] (*val rest : int list = [2] *)		  

(* "as" patterns *)		  
let ((a1,b1) as c1) = (2,3)  (*val a1 : int = 2, val a2 : int = 3, val c1 : int?*int = (2,3) *)
let ((a2,b2) as c2, d2) = ((2,3),4) (*val a2 : int = 2, val b2 :int =3, val c2 : int*int =  (2,3), val d2 : int = 4 *)

(* OR patterns *)

(* This or pattern works... *)			
let rec make_pairs = function
  | ([] | _::[]) -> []
  | a::b::t -> (a,b) :: make_pairs t

(*'a list -> ('a * 'a)list *)


(* but this one doesn't.  Why?  Fix it.*)				   
let rec singleton_or_empty_list = function
  | ([] | _::[]) -> true
  | _ -> false

(* since the first pattern doesn't have the exact same set of identifiers because of h, we need to substitute h with _*)


(* This pattern won't work, due to the *linearity* restriction.  It can be
fixed with "pattern guards" as in Hickey, though that's overkill here. *)   
let twins p = match p with
  | (s1,s2) when s1 = s2 ->true
  | (s,t) -> false

(* Since s used several times in patterns, we just need to change s to other variable names and put when clause to check the condition.*)
			
