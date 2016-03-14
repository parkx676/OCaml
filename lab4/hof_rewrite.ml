(* rewrite each of these function definitions as higher-order functions using the rules in lab4.md *)

let rec append l1 l2 = match l1 with
  | [] -> l2 
  | (h::t) -> h::(append t l2)
	
let rec append = fun l1 -> fun l2 -> 
	match l1 with
  | [] -> l2 
  | (h::t) -> h::(append t l2)

let rec append = fun l1 -> 
	match l1 with
  | [] -> fun l2 -> l2 
  | (h::t) -> fun l2 -> h::(append t l2)

let rec append = fun l1 -> 
	match l1 with
  | [] -> fun l2 -> l2 
  | (h::t) -> fun l2 -> h::(let append1 = (append t) in append1 l2)

let rec append = fun l1 -> 
	match l1 with
  | [] -> fun l2 -> l2 
  | (h::t) -> fun l2 ->let append1 = (append t) in h::( append1 l2)

let rec append = fun l1 -> 
	match l1 with
  | [] -> fun l2 -> l2 
  | (h::t) -> let append1 = (append t) in fun l2 -> h::( append1 l2)
(********************************************************************************)

let rec take_until lst s = match lst with
  | [] -> []
  | (h::t) -> if h = s then [] else h::(take_until t s)

let rec take_until = fun lst -> fun s -> match lst with
  | [] -> []
  | (h::t) -> if h = s then [] else h::(take_until t s)

let rec take_until = fun lst -> match lst with
  | [] -> fun s -> []
  | (h::t) -> fun s -> if h = s then [] else h::(take_until t s)

let rec take_until = fun lst -> match lst with
  | [] -> fun s -> []
  | (h::t) -> fun s -> if h = s then [] else h::(let take_until1 = (take_until t) in take_until1 s)

let rec take_until = fun lst -> match lst with
  | [] -> fun s -> []
  | (h::t) -> fun s -> let take_until1 = (take_until t) in if h = s then [] else h::( take_until1 s)

let rec take_until = fun lst -> match lst with
  | [] -> fun s -> []
  | (h::t) -> let take_until1 = (take_until t) in fun s -> if h = s then [] else h::( take_until1 s)