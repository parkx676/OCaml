type 'a nestedList = Empty | Cons of 'a listEl * 'a nestedList
and 'a listEl = El of 'a | NestEl of 'a nestedList

let nl1 = Cons(NestEl(Cons(NestEl(Cons(NestEl(Cons(El "where" , Cons(El "is" , Cons(El "my", Cons(El "talisman",Empty))))) , Empty)), Cons(El"am",Empty))), Cons((El"I", Cons(El"in" , Cons(El"limbo?",Empty)))))

let nl2 = Cons(NestEl(Cons(NestEl(Cons(NestEl(Cons(NestEl(Cons(El 4, Empty)),Cons(El 3, Empty))),Cons(El 2, Empty))),Cons(El 1,Empty))),Cons( El 2, Cons (El 3, Empty)))

let nl3 = Cons(NestEl(Cons( NestEl(Cons(El 1, Empty)),Cons(	NestEl(Cons(NestEl(Cons(El 2, Empty)),Cons( NestEl(Cons(El 3, Empty)),Cons(El 3,Empty)))),Cons(El 2,Empty)))),Cons(El 1,Empty))

let rec flatten lst = match lst with
  |Empty -> []
  |(Cons(El el, rest)) -> el::(flatten rest)
  |(Cons(NestEl lst, rest)) -> (flatten lst)@(flatten rest)

let nest_depth lst =
  let rec count lst acc = match lst with
  |Empty -> acc
  |(Cons(El i, rest)) -> (count rest (acc+1))
  |(Cons(NestEl lst, rest)) -> if (count lst (acc)) >= (count rest (acc)) then (count lst (acc)) else (count rest (acc))
  in count lst 0
