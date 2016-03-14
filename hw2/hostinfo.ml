(* hostinfo, the "name" of a computer connected to the Internet *)
type hostinfo = IP of int*int*int*int | DNSName of string

(* Here's where your definition of tld goes: *)
let rec tld name = match name with
|IP (a,b,c,d)-> None
|DNSName i -> Some (String.sub i ((String.rindex_from i (String.length i - 1) '.') + 1) ((String.length i - 1) - (String.rindex_from i (String.length i - 1) '.')))
