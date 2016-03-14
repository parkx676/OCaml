type entity =
  Title of entity list
  | Heading of entity list
  | Text of string
  | Anchor of anchor
  | List of entity list
 and anchor = Named of string * (entity list) | HRef of string * (entity list)

type document = { head : entity list ; body : entity list }

(* a few example documents *)
let d1 = { head = [(Title [(Text "cs2041.org")])] ;
	   body = [ (Heading [(Text "CS 2041 Document")]) ;
		    (Text "A short document") ;
		    (Anchor (Named ("here", []))) ;
		    (Text "A little more stuff") ;
		    (Anchor (HRef ("#here", [(Text "Click this to go back")]))) ] }

let d2 = { head = [(Title [(Text "github.umn.edu/cs2041-f15/labs2041-f15/lab2")])] ;
	   body = [ (Heading [(Text "Lab 2: Types, Patterns and Recursion")]) ;
		    (Text "Due dates and stuff.") ;
		    (Heading [(Text "Ground rules")]) ;
		    (Text "Work with a partner, and so on.") ;
		    (Heading [(Text "Goals for this lab")]) ;
		    (List [(Text "apply type inference knowledge");
              (Text "see pattern matching examples");
              (Text "write recursive functions")]);
		    (Heading [(Text "Types and Type inference")]) ;
		    (Text "The rest of the lab gets boring quickly...") ] }

let d_err1 = { head = [(Anchor (Named ("notgood", [])))] ;
	       body = [(Text "But sort of boring.")] }

let d_err2 = { head = [] ;
	       body = [(Title [(Text "The Title doesn't go in the body!")])] }

let d_err3 = { head = [(Title [(Text "Title's where it goes but...")])] ;
	       body = [(Anchor (Named ("evenwose", [(Anchor (Named ("nested anchor!", [])))])))] }

(* Example of computing on a document *)
let check_rules { head ; body } =
  let rec check_head el = match el with
    | [] -> true
    | (Title el')::t | (Heading el')::t | (List el')::t -> (check_head el') && (check_head t)
    | (Text _)::t -> check_head t
    | (Anchor _)::t -> false in
  let rec check_body el nest = match el with (* nest = are we inside an Anchor element? *)
    | [] -> true
    | (Title el')::t -> false
    | (Text _)::t -> check_body t nest
    | (Heading el')::t | (List el')::t -> (check_body el' nest) && (check_body t nest)
    (* When we check the elements inside this anchor, set nest to true, but not in the tail*)
    | (Anchor (Named (_,el')))::t
    | (Anchor (HRef (_,el')))::t -> if nest then false else (check_body el' true) && (check_body t nest) in
  (* Initially, nest = false... *)
  (check_body body false) && (check_head head)


let find_headings  { head ; body } =
  let rec find_head el = match el with
  |[] -> []
  |(Heading el')::t -> (Heading el')::find_head t
  | _::t -> find_head t
in find_head body


let extract_text { head ; body } =
  let rec find_text el acc = match el with
  |[] -> if acc = "" then acc else String.sub acc 0 ((String.length acc) -1)
  |(Text s)::t -> find_text t (acc^s^" ")
  |(Heading [(Text s)])::t | (List [(Text s)])::t -> find_text t (acc^s^" ")
  |(Anchor (Named (_,[(Text s)])))::t | (Anchor (HRef (_,[(Text s)])))::t -> find_text t (acc^s^" ")
  |_::t -> find_text t acc
in find_text body ""


(*TA comment (halto004):
  -functions should use mutual recursion to handle the cases of list and entity seperately
  -List type is incorrect, read the instructions
  -you are missing elements in your recursive calls in both functions
  5.5/10
*)
