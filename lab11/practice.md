# 5. Streams and Lazy data structrues

## What is the result of evaluating take_s 5 (pows_s 3)?

C(1, C(8, C(27, C(64, C(125, fun () -> gen 6)))))

[1; 8; 27; 64; 125]

## What is the type of map_s? Why?

('a -> 'b) -> 'a stream -> 'b stream

Function f takes head of 'a stream and produce 'b, and s is obviously 'a stream since its maching case is stream.

## Give an alernative definition of pows_s.

let pow_s n = map_s (fun x -> power n 1 x) (nats_s 1)

## Give a definition for the function odds : 'a lzlist -> 'a lzlist that returns the elements in odd-numbered positions of a lazy list, so if (lztake 6 ll) = [ a0; a1; a2; a3; a4; a5 ] then (lztake 3 (odds ll)) = [ a1; a3; a5 ]

let odds l = let rec ohelper l f = match l with
| LzEmpty -> invalid_arg "No proper input"
| LC(h, t) -> if (f h) then LC(h, lazy(ohelper (Lazy.force t) f)) else ohelper (Lazy.force t) f 
in ohelper l (fun x -> x mod 2 != 0)

## Give a definition for the function bstrings: string -> string -> string lzlist, which generates a lazy list of all strings that can be created by repeated concatenation of a or b. So for example, (lztake 7 (bstrings "0" "1")) should evaluate to [""; "0"; "1"; "00"; "01"; "10"; "11"], and (lztake 6 (bstrings "aa" "b")) should evaluate to ["";"aa";"b";"aaaa";"aab";"baa"].

let bstrings s1 s2 = let rec bhelper o s1 s2 = LC(o, lazy(lzmerge (bhelper (o^s1) s1 s2) (bhelper (o^s2) s1 s2))) in bhelper "" s1 s2  