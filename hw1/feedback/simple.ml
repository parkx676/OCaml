let csvify (a,b) = a^", "^b

let (++) a b = if a+b > 32767 then 32767 else if a+b < -32768 then -32768 else a+b

let vec_add (a, b) (c, d) = (a+.c, b+.d)

let dot (a, b) (c, d) = (a*.c)+.(b*.d)

let perp (a, b) (c, d) = if ((a*.c)+.(b*.d)) = 0.0 then true else false


(* TA COMMENT(halto004):
  Comment your code.
  Looks good.
  20/20

*)
