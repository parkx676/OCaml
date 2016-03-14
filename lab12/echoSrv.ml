(* this line makes the lwt bind infix operator available in scope *)
open Lwt

(* the code to handle connection ending goes here: *)
exception Quit


let close_channels (inp:Lwt_io.input_channel) (outp:Lwt_io.output_channel) = 
Lwt_io.close inp >>= fun () ->
Lwt_io.close outp >>= fun () ->
Lwt.fail Quit;;

       
let echo_handler (inp,outp) =
  (* Here, before main_loop, is where we'll add the input line handler: *)
  let rec handle_input (s:string) =
     if (Str.string_before s 2) = (Str.string_before "/q" 2) then (close_channels inp outp) else Lwt_io.write outp (s^"\n")  in
  
  let rec main_loop () =
    Lwt_io.read_line inp >>= fun l ->
    handle_input l >>= main_loop in
  Lwt.async (fun () -> Lwt.catch main_loop (fun e -> Lwt.return ()))
								 	    
let s = Lwt_io.establish_server (Unix.ADDR_INET(Unix.inet_addr_any, 16384)) echo_handler
let _ = Lwt_main.run (fst (Lwt.wait ()))
