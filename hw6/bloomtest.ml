open Bloom;;

module BloomSparseInt = BloomFilter(SparseSet)(IntHash);;
module BloomBitInt = BloomFilter(BitSet)(IntHash);;
module BloomSparseString = BloomFilter(SparseSet)(StringHash);;
module BloomBitString = BloomFilter(BitSet)(StringHash);;

let insert_list n =
  let rec make n a =  match n with
    | 0 -> a
    | _ -> make (n-1) ((Random.int (1073741824-1))::a)
  in make n [];;

let test_list n =
  let rec make n a =  match n with
    | 0 -> a
    | _ -> make (n-1) ((Random.int (1073741824-1))::a)
  in make n [];;

let build_time f x=
  let start = Sys.time () in
    let y = f x in
      let finish = Sys.time () in
        Printf.printf "build time =    %fs " (finish -. start); y;;

let test_time f x =
  let start = Sys.time () in
    let y = f x in
      let finish = Sys.time () in
        Printf.printf "test time =    %fs " (finish -. start); y;;

let bsi_test_mem tl t =
  let rec counts tl t n = match tl with
    | [] -> n
    | h::ta -> if (BloomSparseInt.mem h t) then (counts ta t (n + 1)) else (counts ta t n)
  in counts tl t 0;;

let bbi_test_mem tl t =
  let rec counts tl t n = match tl with
    | [] -> n
    | h::ta -> if (BloomBitInt.mem h t) then (counts ta t (n + 1)) else (counts ta t n)
  in counts tl t 0;;

let bss_test_mem tl t =
  let rec counts tl t n = match tl with
    | [] -> n
    | h::ta -> if (BloomSparseString.mem h t) then (counts ta t (n + 1)) else (counts ta t n)
  in counts tl t 0;;

let bbs_test_mem tl t =
  let rec counts tl t n = match tl with
    | [] -> n
    | h::ta -> if (BloomBitString.mem h t) then (counts ta t (n + 1)) else (counts ta t n)
  in counts tl t 0;;

let read_input_lines filename =
    let in_file = open_in filename in
    let rec loop acc =
        let next_line = try Some (input_line in_file) with End_of_file -> None in
        match next_line with
            | (Some l) -> loop ((String.sub l 0 ((String.length l)-1))::acc)
            | None -> acc
      in
    let lines = try List.rev (loop []) with _ -> [] in
    let () = close_in in_file in
    lines;;

let ilist = (insert_list 200);;
let tlist = (test_list 1000000);;
let ilist2 = (read_input_lines "top-2k.txt");;
let tlist2 = (read_input_lines "top-1m.txt");;


print_string "SparseInt      : ";;
(build_time BloomSparseInt.from_list ilist);;
let bsi_list = BloomSparseInt.from_list ilist;;
(test_time bsi_test_mem tlist (bsi_list));;
let bsi_fp = (bsi_test_mem tlist (bsi_list));;
Printf.printf "false positive = %i \n" (bsi_fp);;

Printf.printf "BitInt         : ";;
(build_time BloomBitInt.from_list ilist);;
let bbi_list = (BloomBitInt.from_list ilist);;
(test_time bbi_test_mem tlist (bbi_list));;
let bbi_fp = bbi_test_mem tlist (bbi_list);;
Printf.printf "false positive = %i \n" (bbi_fp);;


Printf.printf "SparseString   : ";;
(build_time BloomSparseString.from_list ilist2);;
let bss_list = BloomSparseString.from_list ilist2;;
(test_time bss_test_mem tlist2 (bss_list));;
let bss_fp = bss_test_mem tlist2 (bss_list);;
Printf.printf "false positive = %i \n" (bss_fp);;


Printf.printf "BitString      : ";;
(build_time BloomBitString.from_list ilist2);;
let bbs_list = BloomBitString.from_list ilist2;;
(test_time bbs_test_mem tlist2 (bbs_list));;
let bbs_fp = bbs_test_mem tlist2 (bbs_list);;
Printf.printf "false positive = %i \n" (bbs_fp);;
