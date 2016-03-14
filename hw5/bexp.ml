(* boolexpr parsing with continuations and descriptive exceptions *)
type boolExpr =
  Bool of bool
  | And of boolExpr*boolExpr
  | Or of boolExpr*boolExpr
  | Not of boolExpr
  | Var of string

type token = AND | OR | NOT | LIT of bool | OP | CL | NM of string

let rec lex str =
  let splitlist = Str.full_split (Str.regexp "\\b\\|(\\|)") str in
  let rec tok_splits = function
    | [] -> []
    | (Str.Delim "(")::t -> OP::(tok_splits t)
    | (Str.Delim ")")::t -> CL::(tok_splits t)
    | (Str.Delim _)::t -> tok_splits t
    | (Str.Text s)::t ->
       match String.trim s with
       | "" -> tok_splits t
       | "not" -> NOT::(tok_splits t) | "and" -> AND::(tok_splits t) | "or" -> OR::(tok_splits t)
       | "true" -> (LIT true)::(tok_splits t) | "false" -> (LIT false)::(tok_splits t)
       | "(" -> OP::(tok_splits t) | ")" -> CL::(tok_splits t)
       | _ as s -> (NM s)::(tok_splits t) in
  tok_splits splitlist

let rparse tlist =
  let rec phelp tlist =
    match tlist with
    | (LIT b)::t -> (Bool b, t)
    | (NM s)::t -> (Var s, t)
    | OP::NOT::t -> let (e,t') = phelp t in begin match t' with CL::t'' -> (Not e, t'') | _ -> failwith "unclosed not" end
    | OP::AND::t ->
       let (e1, t1) = phelp t in
       let (e2, t2) = phelp t1 in
       begin match t2 with CL::t' -> (And (e1,e2), t') | _ -> failwith "unclosed and" end
    | OP::OR::t ->
       let (e1,t1) = phelp t in
       let (e2,t2) = phelp t1 in
       begin match t2 with CL::t' -> (Or (e1,e2), t') | _ -> failwith "unclosed or" end
    | _ -> failwith "unexpected token" in
  match phelp tlist with
  | (e,[]) -> e
  | _ -> failwith "tokens beyond end of expression"

(* evaluate a boolExpr (bExp), assuming that only the variables in the (string) list tvars are true *)
let rec reval bExp tvars = match bExp with
  | Bool b -> b
  | And (e1,e2) -> (reval e1 tvars) && (reval e2 tvars)
  | Or (e1,e2) -> (reval e1 tvars) || (reval e2 tvars)
  | Not e -> not (reval e tvars)
  | Var s -> List.mem s tvars

(* try this in utop: reval (rparse (build_deep_not (1 lsl 18))) [] *)
let build_deep_not n =
  let rec build_close_str n acc = if n=0 then acc else build_close_str (n-1) (CL::acc) in
  let rec build_not_str n acc = if n=0 then acc else build_not_str (n-1) (OP::(NOT::acc))
  in build_not_str n ((LIT true)::build_close_str n [])


(* Here's where you build the continuations & descriptive exceptions-based versions *)
exception Unclosed of string  * token
exception Unused of string * token
exception SyntaxError of string * token
exception EmptyTokenList of string
exception ErrorMessage of unit


let eval bExp tvars =
  let rec keval bExp tvars f = match bExp with
    | Bool b -> f b
    | And (e1, e2) -> keval e1 tvars (fun result -> (f (result && keval e2 tvars (fun result -> (f result)))))
    | Or (e1,e2) ->  keval e1 tvars (fun result -> (f (result || keval e2 tvars (fun result -> (f result)))))
    | Not e -> keval e tvars (fun result -> f (not(result)))
    | Var s -> List.mem s tvars
  in keval bExp tvars (fun x -> x)

let parse tlist =
  let rec kparse tlist f p= match tlist with
    | (LIT b)::h::t -> f (Bool b) (h::t) h
    | (LIT b)::t -> f (Bool b) t (LIT b)
    | (NM s)::h::t -> f (Var s) (h::t) h
    | (NM s)::t -> f (Var s) t (NM s)
    | OP::NOT::h::t -> kparse (h::t) (fun res tlist h'-> (match tlist with
      | CL::h'::t' -> (f (Not(res)) (h'::t') h')
      | CL::h' -> (f (Not(res)) h' CL)
      | _ -> raise(Unclosed ("unclosed not after this token :", h')))) h
    | OP::AND::h::t -> kparse (h::t) (fun res tlist h'-> (kparse tlist (fun res2 tlist' h'' -> (match tlist' with
      | CL::h3::t' -> (f (And(res, res2)) (h3::t') h3)
      | CL::t' -> (f (And(res, res2)) t' CL)
      | _ -> raise(Unclosed ("unclosed and after this token :", h'')))) h')) h
    | OP::OR::h::t -> kparse (h::t) (fun res tlist h'-> (kparse tlist (fun res2 tlist' h'' -> (match tlist' with
      | CL::h3::t' -> (f (Or(res, res2)) (h3::t') h3)
      | CL::t' -> (f (Or(res, res2)) (t') CL)
      | _ -> raise(Unclosed ("unclosed or after this token :", h'')))) h')) h
    | _ -> raise (SyntaxError("unexpected token encountered here :", p))
  in kparse tlist (fun (h:boolExpr) (t:token list) p -> (match t with
  | [] -> h
  | h::t -> raise (Unused ("tokens beyond end of expression after this token :", h)))) (match tlist with h::t -> h | [] -> raise (EmptyTokenList("Empty list.")))

let rec string_of_expr expr = match expr with
  | Bool b -> "Bool "^string_of_bool b
  | Var s -> "Var "^s
  | And (e1, e2) -> "And ("^(string_of_expr e1)^", "^(string_of_expr e2)^")"
  | Or (e1, e2) -> "Or ("^(string_of_expr e1)^", "^(string_of_expr e2)^")"
  | Not (e) -> "Not ("^string_of_expr e^")"

let rec string_of_token t = match t with
  | AND -> "AND"
  | OR -> "OR"
  | NOT -> "NOT"
  | LIT b -> (string_of_bool b)
  | OP -> "OP"
  | CL -> "CL"
  | NM s -> s

let query str lst = match (try (parse(lex str)) with
    | Unused (s, v) -> raise(ErrorMessage (print_string (s^" Error caused by: "^(string_of_token v)^"  ")))
    | Unclosed (s, v) -> raise(ErrorMessage (print_string (s^" Error caused by: "^(string_of_token v)^"  ")))
    | SyntaxError (s, v) -> raise(ErrorMessage (print_string (s^" Error caused by: "^(string_of_token v)^"  ")))
    | EmptyTokenList s -> raise(ErrorMessage (print_string(s)))) with
  |e -> (match (eval e lst) with b -> print_string("Expression is: "^string_of_expr(e)^" , and Result is: "^(string_of_bool b)^"  "))
