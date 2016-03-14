let rec map f lst =
  match lst with
  | [] -> []
  | h::t -> (f h)::(map f t)

(* fold_left in Ocaml *)
let rec fold f acc lst =
  match lst with
  | [] -> acc
  | h::t -> fold f (f acc h) t

(* fold_right in Ocaml *)
let rec reduce f lst init =
  match lst with
  | [] -> init
  | h::t -> f h (reduce f t init)

(* Map, Fold and Reduce *)
let append l1 l2 = reduce (fun x y -> y@[x]) l2 l1

let filter p lst = reduce (fun x y -> if (p x) then y@[x] else y) lst []

let list_cat = fold (fun x y-> x^y) ""

let list_fst = map (fun x -> match x with (i, _) -> i)



(* Intersection Size *)
let mem x lst = reduce (fun h init -> if h = true then true||init else init) (map ((=) x) lst) false


let count_intersection lst1 lst2 = fold (fun acc elm -> let rec loop acc lst1 =  match lst1 with | [] -> acc | h::t -> if h = elm then (acc+1) else loop acc t in loop acc lst1) 0 lst2


let check_set lst = fold ( fun ((l:'a list),(b:bool)) elm -> if List.mem elm l then ((elm::l),false) else ((elm::l),true)) ([],false) lst



(* assoc_max *)

let assoc_max lst = match lst with
| [] -> None
| h::t -> (match (fold (fun x y -> match (x, y) with ((i, j), (k,l)) -> if j >= l then x else y) h lst) with
          |(i, j) -> Some i)

(* TA COMMENT (leid0065): Unfinished but sufficient attempt. 1/1 *)













