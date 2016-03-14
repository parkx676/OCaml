(* Your inferred type: 'a -> ('a->'b) -> 'b
   Explanation of type: f is the function takes x which is 'a type element and returns 'b
   Annotate the definition below: *)
let (|>) = fun x f -> (f x)

let (|>) : 'a -> ('a->'b) -> 'b = fun x f -> (f x)

(* Your inferred type: ('a -> bool) -> 'a list -> 'a list * 'a list
   Explanation of type: p is predicate which takes 'a elements from 'a list lst
                      and returns 'a list * 'a list tuple.
   Annotate the definition below: *)
let rec partition p lst =
  match lst with
  | [] -> ([],[])
  | h::t -> let (l1,l2) = (partition p t) in
	    if (p h) then (h::l1, l2) else (l1,h::l2)

let rec partition (p:'a -> bool) (lst: 'a list) : 'a list * 'a list =
  match lst with
  | [] -> ([],[])
  | h::t -> let (l1,l2) = (partition p t) in
	    if (p h) then (h::l1, l2) else (l1,h::l2)


(* Your inferred type: ('a -> bool) -> 'a list -> bool
   Explanation of type: It has two parameter since it is abbreviated by function.
                  First one is predicate which takes 'a element from 'a list; second parameter.
   Annotate the definition below: *)

(*exists has error on last sentense when it calls it self. Missing predicate p*)
let rec exists = fun p ->
  function
  | [] -> false
  | (h::t) -> (p h) || (exists t)

let rec exists (p: 'a -> bool) (lst: 'a list) : bool =
  match lst with
  | [] -> false
  | (h::t) -> (p h) || (exists p t)
