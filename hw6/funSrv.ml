(* I added some colored output for chatting client's notifications like <left chat> and <Joined>.*)

open Lwt

module Server = struct
    (* a list associating user nicknames to the output channels that write to their connections *)
    (* Once we fix the other functions this should change to []*)
    let sessions = ref [("",Lwt_io.null)]
    exception Quit

    (* replace Lwt.return below with code that uses Lwt_list.iter_p to
       print sender: msg on each output channel (excluding the sender's)*)
    let rec broadcast sender msg = Lwt_list.iter_p (fun x -> match x with
                        (n, o) ->
                            if n = sender then Lwt.return() else Lwt_io.fprintl o (sender^": "^msg)) !sessions

    (* remove a session from the list of sessions: important so we don't try to
       write to a closed connection *)
    let remove_session nn =
      sessions := List.remove_assoc nn !sessions;
      broadcast nn "\027[31m <left chat>\027[37m" >>= fun () ->
      Lwt.return ()

    (* Modify to handle the "Quit" case separately, closing the channels before removing the session *)
    let handle_error e nn inp outp = match e with
      | Quit -> Lwt_io.close inp >>= fun () -> Lwt_io.close outp >>= fun () -> remove_session nn
      | _ -> remove_session nn

    (* modify sessions to remove (nn,outp) association, add (new_nn,outp) association.
       also notify other participants of new nickname *)
    let change_nn nn outp new_nn =
      let rec change nn outp new_nn l = match l with
        | (n, o)::t -> if n = nn then sessions := (new_nn, o)::t else (change nn outp new_nn (t@[(n, o)]))
        | [] -> invalid_arg "This should not be happen!"
      in (change nn outp new_nn !sessions);
      broadcast new_nn ("\027[31m<changed nick to "^new_nn^">\027[37m") >>= fun () -> Lwt.return ()

    let chat_handler (inp, outp) =
      let nick = ref "" in
      (* replace () below with code to
         + obtain initial nick(name),
         + add (nick,outp) to !sessions, and
         + announce join to other users *)
      let _ = Lwt_io.fprintl outp "\027[36mEnter initial nick: \027[37m" >>= fun () ->
       Lwt_io.read_line inp >>= fun s ->
          Lwt.return(nick := s) >>= fun () ->
              Lwt.return(sessions := !sessions@[(!nick, outp)]) >>= fun () ->
                broadcast !nick "\027[31m<joined>\027[37m" in
      (* modify handle_input below to detect /q, /n, and /l commands *)
      let handle_input l =
        let list me outp = Lwt_list.iter_p (fun x -> match x with (n, o) -> Lwt_io.fprintl outp n) !sessions in
          match (String.sub l 0 2) with
          | "/l" -> list !nick outp
          | "/n" -> change_nn !nick outp (String.sub l 3 (String.length l - 3)) >>= fun () -> Lwt.return(nick := (String.sub l 3 (String.length l - 3)))
          | "/q" -> Lwt.fail Quit
          | _ -> broadcast !nick l in
      let rec main_loop () =
	    Lwt_io.read_line inp >>= handle_input >>= main_loop in
      Lwt.async (fun () -> Lwt.catch main_loop (fun e -> handle_error e !nick inp outp))
  end

let port = if Array.length Sys.argv > 1 then int_of_string (Sys.argv.(1)) else 16384
let s = Lwt_io.establish_server (Unix.ADDR_INET(Unix.inet_addr_any, port)) Server.chat_handler
let _ = Lwt_main.run (fst (Lwt.wait ()))
let _ = Lwt_io.shutdown_server s (* never executes; you might want to use it in utop, though *)
