type expr =
  Const of int | Boolean of bool
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr
  | If of expr * expr * expr
  | Let of string * expr * expr
  | Name of string
  | And of expr * expr
  | Or of expr * expr
  | Not of expr
  | Lt of expr * expr
  | Eq of expr * expr
  | Gt of expr * expr
  | Print of expr

type expType = Int | Bool | Unit 

(* Type to represent a lexical environment of the program, e.g. the current stack of variables and the values they are bound to *)
type envType = (string * result) list
 (* Type to represent a value in the program *)
 and result = IntResult of int | BoolResult of bool | UnitResult 

(* evaluate an expression in a lexical environment *)
let rec eval exp env = match exp with
  | Const n -> IntResult n
  | Boolean b -> BoolResult b
  | Add (e1,e2) -> evalInt (+) e1 e2 env
  | Mul (e1,e2) -> evalInt ( * ) e1 e2 env
  | Sub (e1,e2) -> evalInt (-) e1 e2 env
  | Div (e1,e2) -> evalInt (/) e1 e2 env
  | If (cond,thn,els) -> evalIf cond thn els env
  | Let (nm,vl,exp') -> evalLet nm vl exp' env
  | Name nm -> List.assoc nm env
  | And (e1,e2) -> evalBool (&&) e1 e2 env
  | Or (e1,e2) -> evalBool (||) e1 e2 env
  | Not e -> let (BoolResult b) = eval e env in BoolResult (not b)
  | Lt (e1, e2) -> evalComp (<) e1 e2 env
  | Eq (e1, e2) -> evalComp (=) e1 e2 env
  | Gt (e1, e2) -> evalComp (>) e1 e2 env
  | Print e -> let () = match eval e env with
		 | UnitResult -> print_string "()"
		 | IntResult i -> print_int i
		 | BoolResult b -> if b then print_string "True" else print_string "False" in
	       let () = print_string "\n" in
	       let () = flush stdout in UnitResult
and evalInt f e1 e2 env =
  let (IntResult i1) = eval e1 env in
  let (IntResult i2) = eval e2 env in
  IntResult (f i1 i2)
and evalIf cond thn els env =
  let (BoolResult b) = eval cond env in
  if b then eval thn env else eval els env
and evalLet name vl exp env =
  let r = eval vl env in
  eval exp ((name,r)::env) 
and evalBool f e1 e2 env =
  let (BoolResult b1) = eval e1 env in
  let (BoolResult b2) = eval e2 env in
  BoolResult (f b1 b2)
and evalComp cmp e1 e2 env =
  let (IntResult i1) = eval e1 env in
  let (IntResult i2) = eval e2 env in
  BoolResult (cmp i1 i2)
	     
(* Type checking/inference: Figure out type for an expression.  Fail if the expression is not well-typed.*)    
let rec typeof exp env = match exp with
  | Const _ -> Int
  | Boolean _ -> Bool
  | Add (e1,e2) | Sub (e1,e2) | Mul (e1,e2)
  | Div (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Int,Int) -> Int
       | _ -> failwith "Arithmetic on non-integer argument(s)")
  | And (e1,e2)
  | Or (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Bool,Bool) -> Bool
       | _ -> failwith "Boolean operation on non-Bool argument(s)")
  | Not e -> if (typeof e env) = Bool then Bool else failwith "Not of non-Boolean"
  | Lt (e1,e2)
  | Gt (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Int,Int) -> Bool
       | _ -> failwith "Comparison of non-integer values" )
  | Eq (e1,e2) ->
     ( match (typeof e1 env, typeof e2 env) with
       | (Int,Int) | (Bool,Bool) | (Unit,Unit) -> Bool
       | _ -> failwith "Equality test on incompatible values" )
  | If (cond,thn,els) ->
     if not ((typeof cond env) = Bool) then failwith "If on non-boolean condition" else
       let (t1,t2) = (typeof thn env, typeof els env) in
       if (t1 = t2) then t1 else failwith "Different types for then/else branches"
  | Name name -> (try List.assoc name env with Not_found -> failwith ("Unbound variable "^name))
  | Let (name,vl,e) ->
     let t = typeof vl env in
     typeof e ((name,t)::env)
  | Print e -> let _ = typeof e env in Unit

let e1 = Let("x",Const 3,
	     Let("y", Const 7,
		 If(Gt(Name "y", Name "x"),Print (Boolean true),Print (Boolean false))))

(* Add two well-typed programs below *)
let p1 = Let("x", Const 5, If (Eq( Name "x", Const 4), Print(Boolean true), Print (Boolean false)))

let p2 = Let("z", Let("x", Const 2, Let("y", Const 3, Add(Name "x", Name "y"))), Let("a", Const 4, If(Gt(Name "z", Name "a"), Print(Name "z"), Print(Name"a"))))

let badtype1 = Let("x", Mul(Const 7, Boolean true),
		   If (Const 1, Const 3, Print(Boolean false)))

(* Add two programs that will fail to type-check below *)
let b1 = Let("a", (Boolean true), If(Eq ( Name "a", Const 5), Print( Name "a"), Print(Boolean false)))

let b2 = If(Eq(Name "a", Name "b"), Print(Boolean true), Print(Const 5))

(* here's where you define find_constants *)
let find_constants expr = 
  let rec find expr res = match expr with
    | Const n -> Const n :: res
    | Boolean b -> Boolean b :: res
    | Add (e1,e2)
    | Mul (e1,e2)
    | Sub (e1,e2) 
    | Div (e1,e2)
    | And (e1,e2)
    | Or (e1, e2)
    | Lt (e1, e2)
    | Eq (e1, e2)
    | Gt (e1, e2) -> (find e1 res) @ (find e2 res)
    | Name nm -> []
    | Print e -> find e res
    | Not e -> find e res
    | If (cond, thn, els) -> (find cond res)@(find thn res)@(find els res)
    | Let (nm,vl,exp') -> (find vl res)@(find exp' res)
  in find expr []
  
			  
(* here's where you define rm_vars *)
let rm_vars expr =
  let rec rm expr = match expr with
    | Const n -> Const n
    | Boolean b -> Boolean b
    | Name nm -> Name nm
    | Add (e1,e2) -> Add(rm(e1),rm(e2))
    | Mul (e1,e2) -> Mul(rm(e1),rm(e2))
    | Sub (e1,e2) -> Sub(rm(e1),rm(e2))
    | Div (e1,e2) -> Div(rm(e1),rm(e2))
    | And (e1,e2) -> And(rm(e1),rm(e2))
    | Or (e1, e2) -> Or(rm(e1),rm(e2))
    | Lt (e1, e2) -> Lt(rm(e1),rm(e2))
    | Eq (e1, e2) -> Eq(rm(e1),rm(e2))
    | Gt (e1, e2) -> Gt(rm(e1),rm(e2))
    | Print e -> Print(rm(e))
    | Not e -> Not(rm(e))
    | If (cond, thn, els) -> If (rm(cond), rm(thn), rm(els))
    | Let (nm, vl, exp') ->  match vl with
      | Const n -> let rec rp_con exp = match exp with
	| Const n -> Const n
	| Boolean b -> Boolean b
	| Name nm -> Const 0
	| Add (e1,e2) -> Add(rp_con(e1),rp_con(e2))
	| Mul (e1,e2) -> Mul(rp_con(e1),rp_con(e2))
	| Sub (e1,e2) -> Sub(rp_con(e1),rp_con(e2))
	| Div (e1,e2) -> Div(rp_con(e1),rp_con(e2))
	| And (e1,e2) -> And(rp_con(e1),rp_con(e2))
	| Or (e1, e2) -> Or(rp_con(e1),rp_con(e2))
	| Lt (e1, e2) -> Lt(rp_con(e1),rp_con(e2))
	| Eq (e1, e2) -> Eq(rp_con(e1),rp_con(e2))
	| Gt (e1, e2) -> Gt(rp_con(e1),rp_con(e2))
	| Print e -> Print(rp_con(e))
	| Not e -> Not(rp_con(e))
	| If (cond, thn, els) -> If (rp_con(cond), rp_con(thn), rp_con(els))
		   in Let (nm, vl,(rp_con exp'))
      | Boolean b -> let rec rp_bool exp = match exp with
	| Const n -> Const n
	| Boolean b -> Boolean b
	| Name nm -> Boolean false
	| Add (e1,e2) -> Add(rp_bool(e1),rp_bool(e2))
	| Mul (e1,e2) -> Mul(rp_bool(e1),rp_bool(e2))
	| Sub (e1,e2) -> Sub(rp_bool(e1),rp_bool(e2))
	| Div (e1,e2) -> Div(rp_bool(e1),rp_bool(e2))
	| And (e1,e2) -> And(rp_bool(e1),rp_bool(e2))
	| Or (e1, e2) -> Or(rp_bool(e1),rp_bool(e2))
	| Lt (e1, e2) -> Lt(rp_bool(e1),rp_bool(e2))
	| Eq (e1, e2) -> Eq(rp_bool(e1),rp_bool(e2))
	| Gt (e1, e2) -> Gt(rp_bool(e1),rp_bool(e2))
	| Print e -> Print(rp_bool(e))
	| Not e -> Not(rp_bool(e))
	| If (cond, thn, els) -> If (rp_bool(cond), rp_bool(thn), rp_bool(els))
		   in Let (nm, vl, rp_bool exp')
  in rm expr
		     
