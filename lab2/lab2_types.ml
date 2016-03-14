(* Type inference examples.  For each  *)

(* Intended type of pairwith: 'a -> 'b list -> ('a * 'b) list
   Actual type: 'a -> 'b list -> ('a * 'b) list
   Explanation: Since we do not know what types are x and lst, these should be 'a and 'b initially, and if we see pattern matching, we can derive lst is actually list, so it becomes 'b list. And last pattern show us it constructs tuple list of ('a * 'b) list.
 *)
let rec pairwith x lst =
  match lst with
  | [] -> []
  | (h::t) -> (x,h) :: pairwith x t


(* Intended type of has_any: 'a -> 'b list -> bool
   Actual type: It will be occur an error since last recurrence is missing parameter x.
   Explanation: Since we do not know what types are x and lst, these should be 'a and 'b initially, and if we see pattern matching, we can derive lst is actually list, so it becomes 'b list. And pattern matching returns boolean.
 *)
let rec has_any x lst =
  match lst with
  | [] -> false
  | (h::t) -> x=h || has_any t

(* Intended type of lookup: String -> (String * String) list -> String
   Actual type:  'a -> ('a * String) list -> String
   Explanation: Since we initially do not know what types are key and lst, these should be 'a and 'b initially, and if we see pattern matching, we can derive lst is actually tuple list of ('a * 'b) list. And it retruns String and v has to be String element in tuple, it becomes ('a * String) list.
 *)
let rec lookup key lst =
  match lst with
  | [] -> "No match"
  | (k,v)::t -> if k=key then v else lookup key t
				

(* Intended type of first_of_first : 'a list -> 'a
   Actual type: It will be occur an error since the last line's f1 is 'a and fst requires to take 'a list, instead of 'a.
   Explanation: Since we do not know what is the type of lst, it should be 'a initially, and  we look into recursive fuction, l is 'a list, and f1 takes fst lst so lst must be 'a list and f1 will be 'a. But last line's fst should take 'a list, instead of just 'a.
 *)				
let first_of_first lst =
  let rec fst l = match l with
    | h::t -> h
  and f1 = fst lst in
  fst f1
