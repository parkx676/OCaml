let rec assoc_eq (e:'a) p lst = match lst with
  |[] -> None
  |((a:'a),b)::t -> if p e a then Some b else assoc_eq e p t

let rec assoc_by f l = match l with
  | [] -> None
  | (k,v)::t when f k -> Some v
  | _::t -> assoc_by f t

let assoc_by_eq f lst = match lst with
  |[] -> None
  |(k,v)::t -> assoc_eq k (fun _ y -> f y) lst

let assoc_eq_by e p lst = assoc_by (p e) lst
