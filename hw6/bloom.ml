(* Bloom Filter implementation.  This file will not compile as is. *)
module type memset = sig
    type elt (* type of values stored in the set *)
    type t (* abstract type used to represent a set *)
    val mem : elt -> t -> bool
    val empty : t
    val is_empty : t -> bool
    val add : elt -> t -> t
    val from_list : elt list -> t
    val union : t -> t -> t
    val inter : t -> t -> t
  end

(* Define the hashparam signature here *)
module type hashparam = sig
    type t
    val hashes : t -> int list
end

(* Define SparseSet module here, using the Set.Make functor *)
module SparseSet : memset with type elt = int = struct
include Set.Make(struct
                  type t = int
                  let compare = Pervasives.compare
                end)
let rec from_list l = match l with [] -> empty | h::t -> add h (from_list t)
end

(* Fill in the implementation of the memset signature here.  You'll need to expose the elt type *)
module BitSet : memset with type elt = int = struct
    type elt = int
    type t = string
    (* Some helper functions... bitwise &, bitwise | of two char values: *)
    let (&*) c1 c2 = String.make 1 (Char.chr ((Char.code c1) land (Char.code c2)))
    let (|*) c1 c2 = String.make 1 (Char.chr ((Char.code c1) lor (Char.code c2)))
    (* bitwise or of two strings: *)
    let rec (&@) s1 s2 = match (s1, s2) with
      | ("", s) | (s, "") -> ""
      | _ -> (s1.[0] &* s2.[0]) ^ ((Str.string_after s1 1) &@ (Str.string_after s2 1))
    let rec (|@) s1 s2 = match (s1,s2) with
      | ("",s) | (s, "") -> s
      | _ -> (s1.[0] |* s2.[0]) ^ ((Str.string_after s1 1) |@ (Str.string_after s2 1))
    (* single-character string with bit i set: *)
    let strbit i = String.make 1 (Char.chr (1 lsl (i land 7)))
    let make_str_t i s =
      let rec m_str c s = match c with
      | 0 -> s^(String.make 1 (Char.chr (1 lsl (i mod 8))))
      | _ -> m_str (c - 1) (s^"\000")
      in m_str (i/8) s
    let mem s t = if (&@) (String.make 1 (t.[s/8])) (strbit s) = "\000" then false else true
    let empty = ""
    let is_empty t = if t = "" then true else false
    let add s t = (|@) (make_str_t s "") t
    let rec union t1 t2 = match (t1, t2) with
      | ("", "") -> ""
      | ("", t2) -> t2
      | (t1, "") -> t1
      | (t1, t2) -> (|@) t1 t2
    let rec inter t1 t2 = match (t1, t2) with
      | ("", "") | ("", _) | (_, "") -> ""
      | (t1, t2) -> (&@) t1 t2
    let from_list l = List.fold_left (fun s e -> add e s) "" l
  end

(* Fill in the implementation of a BloomFilter, matching the memset signature, here. *)
(* You will need to add some sharing constraints to the signature below. *)
module BloomFilter(S : memset with type elt = int)(H : hashparam) : memset with type elt = H.t and type t = S.t = struct
    type elt = H.t
    type t = S.t
    (* Implement the memset signature: *)
    let mem e t = List.for_all (fun e -> S.mem e t) (H.hashes e)
    let empty = S.empty
    let is_empty t = S.is_empty t
    let add e t = List.fold_left (fun t e -> S.add e t) t (H.hashes e)
    let union t1 t2 = S.union t1 t2
    let inter t1 t2 = S.inter t1 t2
    let from_list l = S.from_list (List.fold_left (fun li e -> li@H.hashes e) [] l)
  end

(* A hashparam module for strings... *)
module StringHash = struct
    type t = string (* I hash values of type string *)
    let hlen = 15
    let mask = (1 lsl hlen) - 1
    let hashes s =
      let rec hlist n h = if n = 0 then [] else (h land mask)::(hlist (n-1) (h lsr hlen)) in
      hlist 4 (Hashtbl.hash s)
  end

(* Add the IntHash module here *)

module IntHash = struct
    type t = int
    let hashes i = [((795*i + 962) mod 1031); ((386*i + 517) mod 1031); ((937*i + 693) mod 1031)]
  end
