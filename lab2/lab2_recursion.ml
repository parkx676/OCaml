(* Recursion, tail recursion, nested functions.  Your definitions of unzip, list_product, and list_deriv go here. *)

let rec unzip lst = match lst with
  |[] -> ([],[])
  |((a,b)::t) -> let c, d = unzip t in (a::c, b::d)

  (* ('a * 'b) list -> 'a list * 'b list  It takes 'a * 'b tuple list and returns 'a list * 'b list tuple*)

let list_cat lst =
  let rec tail_list_cat l res = match l with
    |[] -> res
    |(h::t) -> list_cat t (res^h)
  in tail_list_cat lst ""

let list_deriv lst =
  let rec tail_list_deriv l acc = match l with
    |([] | _::[]) -> acc
    |f::s::t ->  tail_list_deriv (s::t) (acc @[(s-f)])
  in tail_list_deriv lst []
