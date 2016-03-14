(* add up the integers greater than 0 and at most n *)
let rec nsum n = if n < 0 then 0 else n + nsum (n - 1)
(* compute 0 + 1 + 2 + ... + 10 *)
<<<<<<< HEAD
let n10 = nsum (-1)
=======
let n10 = nsum (-1) 
>>>>>>> b4ee22056aaf8cf6e9c453b0c1d5064778665adf
