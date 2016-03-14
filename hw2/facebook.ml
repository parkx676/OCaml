(* A hypothetical scaled-down "database" structure for a social network. *)
type user_id = UID of int
type user = { id: user_id ; name : string ; private_data : string ; friends : user_id list }
type post_id = PID of int
type wall_post = { pid : post_id ; uid : user_id ; contents: string }
type database = { users : user list ; wall_posts : wall_post list }

let harry = { id = (UID 1) ; name = "Harry Potter" ; private_data = "The Chosen One" ;
	      friends = [ (UID 2) ; (UID 3) ] }
let hermione = { id = (UID 2) ; name = "Hermione Granger" ; private_data = "Hogwarts: A History" ;
		 friends = [ (UID 1) ; (UID 3) ] }
let ron = { id = (UID 3) ; name = "Ronald Weasley" ; private_data = "Er, what now?" ;
	    friends = [ (UID 1) ; (UID 2) ] }
let viktor = { id = (UID 4) ; name = "Viktor Krum" ; private_data = "Wronksi Feint" ;
	       friends = [ (UID 2) ; (UID 5) ] }
let igor = { id = (UID 5) ; name = "Igor Karkaroff" ; private_data = "Former Death Eater" ;
	     friends = [ (UID 4) ] }

let hermiones_post = { pid = (PID 1); uid = (UID 2) ; contents = "I read about it in Hogwarts: A History" }
let harrys_post = { pid = (PID 2) ; uid = (UID 1) ; contents = "Horcruxes are hard to find!" }
let viktors_post = { pid = (PID 3) ; uid = (UID 4) ; contents = "Quidditch is better than football." }
let rons_post = { pid = (PID 4) ; uid = (UID 3) ; contents = "Magic is cool." }
let harrys_second_post = { pid = (PID 5) ; uid = (UID 1) ; contents = "I dunno, I kinda miss he-who-shall-not-be-named." }

let hw = { users = [harry; hermione; ron] ; wall_posts = [hermiones_post ; harrys_post ; rons_post ; harrys_second_post ] }
let ds = { users = [viktor ; igor ] ; wall_posts = [ viktors_post ] }



let rec check_wp wp ul = match ul with
|[] -> false
|h::t -> if wp.uid = h.id then true else check_wp wp t


let check_friends u1 hw1 =
	let rec check u hw = match u with
	|[] -> true
	|h::t -> if List.mem h (List.map (fun x -> x.id) hw) then (check t hw) else false
in check u1.friends hw1


let check_db db =
		let rec wall wlist = match wlist with
		|t::[] -> if (check_wp t db.users) then true else false
		|h::h2::t -> if (check_wp h db.users) then (check_wp h2 db.users) else false in
		let rec user ulist = match ulist with
		|t::[] -> if (check_friends t db.users) then true else false
		|h::h2::t -> if (check_friends h db.users) then (check_friends h2 db.users) else false in
	(wall db.wall_posts)&&(user db.users)
