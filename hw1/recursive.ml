let rec range h t = if h>=t then [] else h::(range (h+1) t)

let rec range_step h t s = match (h,t,s) with
| (h,t,0) -> []
| (h,t,s) -> if h < t && h+s > h then h::(range_step (h+s) t s) else if h > t && h+s < h then h::(range_step (h+s) t s) else []

let rec take n lst = match (n,lst) with
| (0, _) -> []
| (_, []) -> []
| (_, h::t) -> if n < 0 then invalid_arg "take: negative argument" else h::(take (n-1) t)
