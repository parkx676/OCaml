
type arithToken = PLUS | TIMES | NEG | DIV | CONST of float
						       
let token_list s =
  (* Don't worry if you don't understand these first two lines.
     They separate a string into a list of substrings separated by one 
     or more whitespace characters, for example if s = "1.3    4.5 +" then 
     wlist will be ["1.3"; "4.5"; "+"] *)    
  let sep_re = Str.regexp "\\( \\|\012\\|\r\\|\n\\|\t\\)+" in
  let wlist = Str.split sep_re s in
  let rec tokens wl = match wl with
    | "+"::t -> PLUS :: (tokens t)
    | "*"::t -> TIMES :: (tokens t)
    | "-"::t -> NEG::(tokens t)
    | "/"::t -> DIV::(tokens t)
    | s::t -> (CONST (float_of_string s))::(tokens t)
    | [] -> []
  in tokens wlist 

type arithExpr = ConstExpr of float | NegExpr of arithExpr | AddExpr of arithExpr * arithExpr | MultExpr of arithExpr * arithExpr | DivExpr of arithExpr * arithExpr
															     
let rpnParse tlist = 
  let rec parser tlist stk = match tlist with 
    | [] -> stk
    | (CONST f)::t -> parser t ((ConstExpr f)::stk)
    | NEG::t -> (match stk with e1::stk' -> parser t ((NegExpr e1)::stk') | _ -> failwith "stack underflow")  
    | PLUS::t -> (match stk with e1::e2::stk' -> parser t ((AddExpr (e1,e2))::stk') | _ -> failwith "stack underflow")
    | TIMES::t -> (match stk with e1::e2::stk' -> parser t ((MultExpr (e1,e2))::stk') | _ -> failwith "stack underflow")
    | DIV::t -> (match stk with e1::e2::stk' -> parser t ((DivExpr (e2, e1))::stk') | _ -> failwith "stack underflow")
  in let stack = parser tlist [] in
     match stack with
     |[e] -> e
     | _ -> failwith "nonempty stack" 
  
let rec arithExpEval = function
  | ConstExpr f -> f 
  | NegExpr e -> 0. -. (arithExpEval e)
  | AddExpr (e1,e2) -> (arithExpEval e1) +. (arithExpEval e2)
  | MultExpr (e1,e2) -> (arithExpEval e1) *. (arithExpEval e2)
  | DivExpr (e1, e2) -> (arithExpEval e1) /. (arithExpEval e2)


let num1 = AddExpr(ConstExpr 1.414, MultExpr(ConstExpr 3.14, ConstExpr 2.))
let num2 = AddExpr(ConstExpr 5.2, ConstExpr 2.8)

let string1 = "1.414 3.14 2 * +"
let string2 = "5.2 2.8 +"



(* and two bindings that evaluate strings that correspond to division in RPN here *)
 
let divresult1 = arithExpEval (rpnParse (token_list "2 4 /"))
let divresult2 = arithExpEval (rpnParse (token_list "6 3 /"))			       
