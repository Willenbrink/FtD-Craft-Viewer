open Util
open Cli

let personal_cons = "/home/sewi/From\\ The\\ Depths/Player\\ Profiles/Ropianos/Constructables/"
let ftd_res = "/home/sewi/.local/share/Steam/steamapps/common/From\\ The\\ Depths/From_The_Depths_Data/StreamingAssets/"

let bp_path = personal_cons
let bp_path = ftd_res

let find regex path =
  let ic = Unix.open_process_in ("fd " ^ regex ^ " " ^ path) in
  let res = ref [] in
  (try
    while true
    do
      res := input_line ic :: !res
    done
   with End_of_file -> ());
  !res


let main () =
  let get_files file_list =
    file_list
    |> List.sort (String.compare)
    |> List.map (fun path -> Str.split (Str.regexp "/") path |> List.rev |> List.hd, path)
  in
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
  let constructs () =
    find ".*\\.blueprint$" bp_path
    |> get_files
    |> try_and_count (try_parse Ftd_rep.parse_construct)
  in
  let items () =
    find ".*\\\\.item$" ftd_res
    |> get_files
    |> try_and_count (try_parse Item.item_of_yojson)
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
    main ()
  with exn -> Printexc.print_backtrace stderr;
    match exn with
      Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error (exn, json) ->
       Printf.fprintf stderr "Exception:\n%s\n\nRelevant JSON:\n%s\n" (Printexc.to_string exn) (Yo.show json)
    | exn ->
      Printexc.to_string exn
      |> Printf.fprintf stderr "Exception:\n%s\n"
