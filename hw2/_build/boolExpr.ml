let wordlist s =
  let splitlist = Str.full_split (Str.regexp "\\b\\|(\\|)") s in
  let rec filter_splist lst = match lst with
    | [] -> []
    | (Str.Delim "(")::t -> "(" :: (filter_splist t)
    | (Str.Delim ")")::t -> ")" :: (filter_splist t)
    | (Str.Delim _) :: t -> filter_splist t
    | (Str.Text s) :: t -> let s' = String.trim s in
			   let t' = (filter_splist t) in
			   if not (s' = "") then s' :: t' else t'
  in filter_splist splitlist


type token = STR of string | T | TRUE| F | FALSE | AND | OR | NOT | OPEN | CLOSE

let rec tokens_p p lst = match lst with
  | [] -> []
  | h::t -> if p h then
    match h with
    | "(" -> OPEN::(tokens_p p t)
    | ")" -> CLOSE::(tokens_p p t)
    | "and" -> AND::(tokens_p p t)
    | "or" -> OR::(tokens_p p t)
    | "not" -> NOT::(tokens_p p t)
    | "T" -> T::(tokens_p p t)
    | "F" -> F::(tokens_p p t)
    | s -> (STR s)::(tokens_p p t)
  else invalid_arg "Unknown or invalid tokens in the input"

let rec lowervars s= match s with
  |"" -> true
  |s -> if ('a' <= s.[0] && s.[0] <= 'z') || ('0' <= s.[0] && s.[0] <='9') then lowervars (String.sub s 1 ((String.length s)-1)) else false

let rec tokens lst = match lst with
  |[] -> []
  |h::t ->
    if (lowervars h) then
      match h with
      | "(" -> OPEN::(tokens t)
      | ")" -> CLOSE::(tokens t)
      | "and" -> AND::(tokens t)
      | "or" -> OR::(tokens t)
      | "not" -> NOT::(tokens t)
      | "T" -> T::(tokens t)
      | "F" -> F::(tokens t)
      | s -> (STR s)::(tokens t)
    else (tokens t)

type boolExpr = VarExpr of string|ConstExpr of bool |AndExpr of boolExpr * boolExpr |OrExpr of boolExpr * boolExpr |NotExpr of boolExpr

(* A token list representing a expression is either
   + a CONST token :: <more tokens>
   + an OPEN PAREN token :: a NOT token :: <a token stream representing a boolean expression> @ (a CLOSE PAREN token :: <more tokens>)
   + an OPEN PAREN token :: an AND token :: <a token list representing a boolean expression> @
                                            <a token list representing a boolen expression> @ a CLOSE PAREN token :: <more tokens>
   + an OPEN PAREN token :: an OR token :: <a token list representing a boolean expression> @
                                           <a token list representing a boolen expression> @ a CLOSE PAREN token :: <more tokens>
   any other list is syntactically incorrect. *)

let parse_bool_exp tl =
  let rec parser tl stk = match tl with
    | [] -> stk
    | [CLOSE] -> stk@[]
    | CLOSE::more -> stk@(parser more [])
    | TRUE::more -> (parser more (stk@[(ConstExpr true)]))
    | FALSE::more -> (parser more (stk@[(ConstExpr false)]))
    | T::more -> (parser more (stk@[(ConstExpr true)]))
    | F::more -> (parser more (stk@[(ConstExpr false)]))
    | (STR s)::more -> (parser more (stk@ [(VarExpr s)]))
    | OPEN::NOT::more -> (match (parser more stk) with e1::stk' -> [NotExpr(e1)] @ stk'| _ -> invalid_arg "Invalid Syntax1")
    | OPEN::AND::more -> (match (parser more stk) with e1::e2::stk' -> [AndExpr(e1,e2)] @ stk' | _ -> invalid_arg "Invalid Syntax2")
    | OPEN::OR::more -> (match (parser more stk) with e1::e2::stk' -> [OrExpr(e1,e2)] @ stk'| _ -> invalid_arg "Invalid Syntax3")
    | _ -> invalid_arg "Invalid Syntax4"
  in let stack = parser tl [] in
  match stack with
  |[h] -> h
  |h::t -> h
  | _ -> invalid_arg "Invalid Syntax"



(*
  Should evaluate an expression, given a function mapping variable names to boolean values.
*)

let eval_bool_exp bl p =
  let rec eval bl p = match bl with
    |ConstExpr e -> e
    |VarExpr s -> (p s)
    |NotExpr e -> not (eval e p)
    |AndExpr (e1, e2) -> (eval e1 p) && (eval e2 p)
    |OrExpr (e1, e2) -> (eval e1 p) || (eval e2 p)
  in eval bl p



let () = if Array.length Sys.argv < 2 then () else
  let (_::sExpr::tlist)  = Array.to_list Sys.argv in
  let bExpr = sExpr |> wordlist |> tokens |> parse_bool_exp in
  let result = eval_bool_exp bExpr (fun v -> List.mem v tlist) in
  let () = print_string ((if result then "True" else "False")^"\n") in
  flush stdout
