(*Juhwan Park 3917664
Homework 1*)

let rec forward_search f y dict = match (f, y, dict) with
|(_, _, []) -> []
|(f, y, x::t) -> if (f)x = y then x::(forward_search f y t) else (forward_search f y t);;


(* Open filename, and return a list of lines as strings.  Catches
input_line exceptions, but will raise exceptions caused by open_in *)
let read_input_lines filename =
    let in_file = open_in filename in
    let rec loop acc =
        let next_line = try Some (input_line in_file) with End_of_file -> None in
        match next_line with
            | (Some l) -> loop (l::acc)
            | None -> acc
        in
    let lines = try List.rev (loop []) with _ -> [] in
    let () = close_in in_file in
    lines;;

(*dict takes dictionary file from the given path by
using read_input_lines function and returns string lists*)
let dict = read_input_lines "/usr/share/dict/words";;

(*key takes the first argument as hex string from user input and returns its string value*)
let key = Digest.from_hex(Sys.argv.(1));;

(*result takes result of forward_search as list of strings matched by the given function*)
let result = forward_search (fun x -> Digest.string x) key dict;;

(*If length of result is empty list, then prints "No match found".
else it prints out "Found a match: " and shows first element in list of result*)
if List.length(result) = 0 then
  print_string "No match found\n"
else
  print_string "Found a match: ";
  let first_of_list = List.hd(result) in print_string first_of_list;
  print_string "\n";;



(* TA Comment(meye2058) forward_search Feedback: 12/14
Poor code structure *)