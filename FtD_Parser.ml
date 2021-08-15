open Util
open Cli

let personal_cons = "~/From\\ The\\ Depths/Player\\ Profiles/Ropianos/Constructables/"

let bp_path = personal_cons
let bp_path = ftd_res

let main () =
  let try_parse parser (name,path) =
    try
      if !verbose then Printf.printf "Reading >%s< at path >%s<\n" name path;
      Yojson.Safe.from_file path
      |> parser
      |> Option.some
    with Unsupported_Version v -> Printf.printf "File %s uses unsupported version %s\n" name v; None
  in
  let try_and_count f xs =
    List.fold_left_map (fun acc x -> match f x with None -> (acc + 1,None) | Some x -> (acc,Some x)) 0 xs
    ||> List.filter_map Fun.id
  in
  let items () =
    get_files ".*\\\\.item$" ftd_res
    |> try_and_count (try_parse Item.item_of_yojson)
  in
  let constructs () =
    get_files ".*\\.blueprint$" bp_path
    |> try_and_count (try_parse Ftd_rep.parse_construct)
  in
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
  with exn -> Printexc.print_backtrace stderr;
    match exn with
      Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error (exn, json) ->
       Printf.fprintf stderr "Exception:\n%s\n\nRelevant JSON:\n%s\n" (Printexc.to_string exn) (Yo.show json)
    | exn ->
      Printexc.to_string exn
      |> Printf.fprintf stderr "Exception:\n%s\n"
