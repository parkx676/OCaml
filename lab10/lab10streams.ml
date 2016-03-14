type 'a stream = Cons of 'a * (unit -> 'a stream)
type 'a lazylist = End | Lz of 'a * 'a lazylist lazy_t

let rec take_s n s = match (n,s) with
  | (0,_) -> []
  | (_,Cons(h,t)) -> h::(take_s (n-1) (t ()))

let rec lztake n ll = match(n,ll) with
  | (0,_) | (_,End) -> []
  | (_,Lz(h,t)) -> h::(lztake (n-1) (Lazy.force t))

(* your definition of ustrings goes here: *)
let ustring_s s = 
  let rec ustring i s o= if i = 0 then Cons("", fun () -> ustring (i+1) s o) else Cons(s, fun () -> ustring i (o^s) o) in ustring 0 s s

(* Add definitions for drop_while_s and take_until_s here: *)
let take_until_s us f =
	let rec take_u us f acc = match us with
| Cons(h, t) -> if (f h) then acc else take_u (t ()) f (acc@[h])
	in take_u us f []

(* now add lz_ustring and lztake_until here: *)
let lz_ustring s = let rec lz_helper i s o = if i = 0 then Lz("", lazy(lz_helper (i+1) s o)) else Lz(s, lazy(lz_helper i (o^s) o)) in lz_helper 0 s s

let lztake_until lz_us f = 
  let rec lztake lz_us f acc = match lz_us with
    | End -> acc
    | Lz(h,t) -> if (f h) then acc else (lztake (Lazy.force t) f (acc@[h]))
  in lztake lz_us f []
