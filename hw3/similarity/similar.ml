(* The only explicit recursion in this file should be in this pre-defined function *)
let file_lines fname =
  let in_file = open_in fname in
  let rec loop acc =
    let next_line = try Some (input_line in_file) with End_of_file -> None in
    match next_line with
    | (Some l) -> loop (l::acc)
    | None -> acc
  in
  let lines = try List.rev (loop []) with _ -> [] in
  let () = close_in in_file in
  lines;;

let file_as_string fname = String.concat "\n" (file_lines fname);;

let split_words = Str.split (Str.regexp "\\b");;

(* Your code goes here: *)
(* Read the list of representative text files *)

let prelist_of_texts = file_lines Sys.argv.(1);;
let list_of_texts = List.map (String.trim) prelist_of_texts;;


(* Read	the contents of each text file: *)

let contents_of_texts = List.map (fun x -> file_as_string x) list_of_texts;;

(* Read the contents of the target text file *)

let contents_of_target = file_as_string Sys.argv.(2);;

(* Define the function that converts a string into a list of words *)

let words str= match (String.map (fun c -> if (String.contains ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") c) then c else ' ') str) with
  |i -> let j = split_words i
  in List.filter (fun s -> if (String.contains s ' ') then false else true) j;;

(* Store the list of words from each representative *)

let strlst_of_texts = List.map (words) contents_of_texts;;

(* Convert the target text file into a list of words *)

let strlst_of_target = words contents_of_target;;

(* Use Stemmer.stem to stem all of the words in the input, but only if I can make stemmer work. *)

let stemmed_lst = List.map (fun strlst -> List.map (Stemmer.stem) strlst) strlst_of_texts;;
let stemmed_target = List.map (fun str -> Stemmer.stem str) strlst_of_target;;

(* Define a function to convert a list into a set *)

let to_set lst =  List.fold_left (fun res str -> if (List.mem str res) then res else res@[str] ) [] lst;;

(* Convert all of the stem lists into stem sets *)

let stemset_texts = List.map (fun strlst -> to_set strlst) stemmed_lst;;
let stemset_target = to_set stemmed_target;;

(* Define the similarity function between two sets: size of intersection / size of union *)

let intersection_size lst1 lst2 =
  if List.length(lst1) >= List.length(lst2) then
    List.fold_left (fun res str -> if (List.mem str lst1) then res+1 else res) 0 lst2
  else
    List.fold_left (fun res str -> if (List.mem str lst2) then res+1 else res) 0 lst1;;

let union_size lst1 lst2 =
  if List.length(lst1) >= List.length(lst2) then
    List.fold_left (fun res str -> if (List.mem str lst1) then res else res+1) (List.length(lst1)) lst2
  else
    List.fold_left (fun res str -> if (List.mem str lst2) then res else res+1) (List.length(lst2)) lst1;;

let similarity lst1 lst2 = float_of_int(intersection_size lst1 lst2) /. float_of_int(union_size lst1 lst2);;

(* Find the most similar representative file *)
let lastname = List.nth list_of_texts ((List.length list_of_texts)-1);;

let most_similar =
List.fold_left2 (fun res lst name ->
match res with
(n, s) -> if ((similarity lst stemset_target) >= n) then ((similarity lst stemset_target), name) else (n, s))
    (0.0, lastname) stemset_texts list_of_texts;;

(* print the result *)
print_string "The most similar file to ";;
print_string Sys.argv.(2);;
print_string " was ";;
let print1 = match most_similar with
(n, s) -> s in print_string print1;;
print_string "\n";;
print_string "Similarity: ";;
let print2 = match most_similar with
(n, s) -> string_of_float(n) in print_string print2;;
print_string "\n"


(* this last line just makes sure the output prints before the program exits *)
let () = flush stdout
