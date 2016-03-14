(* lab 9 examples to convert to CPS *)
let rec map f lst = match lst with
  | [] -> []
  | h::t -> (f h)::(map f t)

let rec append l1 l2 = match l1 with
  | [] -> l2
  | h::t -> h::(append t l2)

let rec assoc_update k v lst = match lst with
  | [] -> [(k,v)]
  | (k',_)::t when k'=k -> (k,v)::t
  | kv::t -> kv::(assoc_update k v t)

type 'a btree = Node of 'a * 'a btree * 'a btree | Empty

let rec treeMin t =
  match t with
  | Empty -> None
  | Node(v,l,r) ->
     match (treeMin l, treeMin r) with
     | (None,None) -> Some v
     | (None, Some v') | (Some v', None) ->  Some (min v v')
     | (Some vl, Some vr) -> Some (min (min v vl) vr)

(* CPS versions go here: *)
let map_k f lst =
  let rec kmap lst k = match lst with
    | [] -> k []
    | h::t -> kmap t (fun result -> k ((f h)::result)) in
  kmap lst (fun x -> x)

let append_k l1 l2 =
  let rec append l1 k = match l1 with
    | [] -> k l2
    | h::t -> append t (fun r -> k (h::r))
  in append l1 (fun x -> x)

let assoc_update_k k v lst =
  let rec assoc_update lst a = match lst with
    | [] -> a ((k,v)::[])
    | (k',_)::t when k' = k -> a ((k,v)::t)
    | kv::t -> assoc_update t (fun r -> a (kv::r))
  in assoc_update lst (fun x -> x)
<<<<<<< HEAD
=======

let rec min_k v (fun x ->) o = match 

let treeMin_k t =
  let rec min_k v f o =
      match (l, r) with
      | (Empty, Empty) ->


  in min_k t (fun x -> x) None

treeMin_k (Node (1, Node(2, Node(3, Empty, Empty), Empty), Empty))
>>>>>>> 2fd4e832454f888dbbc7c29b2b8efd4a0fc7acf0
