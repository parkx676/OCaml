(* Types for binary search trees. *)
type 'a btree = Node of 'a * 'a btree * 'a btree | Empty

(* A comparison function cmp should have the following behavior:
   - cmp x y < 0 if x is less than y
   - cmp x y = 0 if x is equal to y
   - cmp x y > 0 if x is greater than y *)
type 'a compare = 'a -> 'a -> int

(* A binary search tree is a binary tree where every element in the
   left subtree of Node(x,left,right) is less than x,
   and every element in the right subtree is greater than x. *)
type 'a bstree = { tree : 'a btree ; cmp : 'a compare }

(* just a helper function for building trees *)
let leaf x = Node(x,Empty,Empty)

let search { tree ; cmp } v =
  let rec tsearch t =
    match t with
    | Empty -> false
    | Node (v',lt,rt) ->
       match (cmp v v') with
       | 0 -> true
       | s when s < 0 -> tsearch lt
       | _ -> tsearch rt
  in tsearch tree

let insert { tree ; cmp } v =
  let rec tinsert t =
    match t with
    | Empty -> (leaf v)
    | Node (v',lt,rt) ->
       match (cmp v v') with
       | 0 -> t
       | s when s < 0 -> Node(v', (tinsert lt), rt)
       | _ -> Node(v', lt, (tinsert rt)) in
  { tree = (tinsert tree) ; cmp }


let treeMin (n: 'a btree) (cmp: 'a compare) = match n with
  |Empty -> None
  |Node(v, _, _) -> (let res = v in
  let rec minval n cmp res= match n with
    | Node(v, Empty, Empty) -> if (cmp v res) >= 0 then res else v
    | Node(v, lt, Empty) -> if (cmp (v) (minval lt cmp res)) >= 0 then (minval lt cmp res) else (minval lt cmp v)
    | Node(v, Empty, rt) -> if (cmp (v) (minval rt cmp res)) >= 0 then (minval rt cmp res) else (minval rt cmp v)
    | Node(v, lt , rt) ->
      if (cmp (minval lt cmp res) (minval rt cmp res)) < 0 then
        if (cmp (v) (minval lt cmp res)) >= 0 then
          (minval lt cmp res)
        else
          v
      else
        if (cmp (v) (minval rt cmp res)) >= 0 then
          (minval rt cmp res)
        else
          v
  in let result = minval n cmp res in match result with
  |i -> Some i)

(* TA COMMENT(moham775): This function should be implemented by inverting the cmp function and using treeMin -3 *)
let treeMax (n: 'a btree) (cmp: 'a compare) = match n with
  |Empty -> None
  |Node(v, _, _) -> (let res = v in
  let rec maxval n cmp res= match n with
    | Node(v, Empty, Empty) -> if (cmp v res) <= 0 then res else v
    | Node(v, lt, Empty) -> if (cmp (v) (maxval lt cmp res)) <= 0 then (maxval lt cmp res) else (maxval lt cmp v)
    | Node(v, Empty, rt) -> if (cmp (v) (maxval rt cmp res)) <= 0 then (maxval rt cmp res) else (maxval rt cmp v)
    | Node(v, lt , rt) ->
      if (cmp (maxval lt cmp res) (maxval rt cmp res)) > 0 then
        if (cmp (v) (maxval lt cmp res)) <= 0 then
          (maxval lt cmp res)
        else
          v
      else
        if (cmp (v) (maxval rt cmp res)) <= 0 then
          (maxval rt cmp res)
        else
          v
  in let result = maxval n cmp res in match result with
  |i -> Some i)
(* TA COMMENT(moham775): 12/15 *)

let check_bst { tree ; cmp } =
  let rec check tree cmp = match tree with
  | Empty -> true
  | Node(v, Empty, Empty) -> true
  | Node(v, lt, Empty) -> (match lt with
    |Node(v', _, _) -> if (cmp v v') > 0 then (check lt cmp) else false)
  | Node(v, Empty, rt) -> (match rt with
    |Node(v', _, _) -> if (cmp v v') <= 0 then (check rt cmp) else false)
  | Node(v, lt, rt) -> (match (lt, rt) with
    |(Node(v', _, _),(Node(v'', _, _))) -> if ((cmp v v') > 0) && ((cmp v v'') <= 0) then (true && (check lt cmp)&&(check rt cmp)) else false)
  in check tree cmp


(* Sample cmp I used for test
cmp = (fun x y -> if x = y then 0 else if x > y then 1 else -1)
*)

(* Four declarations *)
let tree1 = Node(10, Node(9, Node(5, Empty, Node(6, Empty, Empty)), Empty), Node(10, Empty, Node(11, Empty, Empty)))
let tree2 = Node(20, Node(19, Node(15, Empty, Node(17, Empty ,Empty)), Empty), Node(20, Empty, Node(26, Node(24, Empty, Empty), Empty)))

let tree_err1 = (Node(4, Node(5, Empty, Node(1, Empty, Empty)), Node(7, Node(4, Node(4, Node(0, Empty, Empty), Empty), Empty), Empty)))
let tree_err2 = Node(20, Node(26, Empty, Node(2, Empty, Empty)), Node(10, Empty, Empty))
 (*TA COMMENT(zhan2361): check_bst did not use treemin treemax -3
                          failed on 4/4 definition tests -2 10/15*) 
