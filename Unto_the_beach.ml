open Ftd_parser
open Util
open Cli
open Main

let main () =
  let (item_fails, items) = if !read_items || !print_items then items () |>> Option.some ||> Option.some else (None,None) in
  let (cons_fails, cons) = if !read_cons || !print_cons then constructs () |>> Option.some ||> Option.some else (None,None) in
  (match items with
    Some items -> if !print_items then List.iter (fun x -> x |> Item.show_item |> print_endline; print_endline "") items
   | None -> ());
  (match cons with
    Some cons -> if !print_cons then List.iter (fun x -> x |> Ftd_rep.show_construct |> print_endline; print_endline "") cons
   | None -> ());
  (match item_fails with
     Some i -> Printf.printf "Failed to parse %i items.\n" i
   | None -> ());
  (match cons_fails with
     Some i -> Printf.printf "Failed to parse %i constructs.\n" i
   | None -> ())

let () =
  Printexc.record_backtrace true;
  Arg.parse spec (fun _ -> raise Generic) "";
  try
    let start = Sys.time () in
    main ();
    let stop = Sys.time () in
    Printf.printf "Executed in %fs\n" (stop -. start)
  with exn -> Printexc.print_backtrace stdout;
    match exn with
      Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error (exn, json) ->
       Printf.printf "Exception:\n%s\n\nRelevant JSON:\n%s\n" (Printexc.to_string exn) (Yo.show json)
    | exn ->
      Printexc.to_string exn
      |> Printf.printf "Exception:\n%s\n"
