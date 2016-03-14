3 - 2 + 4 (* legal, int, 5)

3.14 * 6 * 6 (* illegal, Because it tries to multiply float with integers)

if 1 then 3 else 4 (* illegal, because 1 is not boolean. if-statment expects bool)

if 1 > 0 then 1 else "no" (* illegal, because then clause used int, else clause needs int as well)

let x = 42 in 42 + y (* illegal, because y is unbounded)

let circ d = 3.14 *. d in circ 4 (* illegal, because d expects float, not int)

let circ d = 3.14 *. d in circ, 4.0 (* legal, float, 12.56)

let x = 2 in let y = x + 3 in let x = y + x in x  (* legal, int, 7)

let z z = z ^ "z" in z "cheez" (* legal, String, "cheezz")

let x = "one" in let y = 1,x in let x = 2 in y+x (* illegal, because y takes a tuple but last equation expected y to be integer.)

(* TA COMMENT(moham775): 20/20 *)