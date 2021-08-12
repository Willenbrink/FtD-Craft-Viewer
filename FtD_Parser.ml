open Util

let personal_cons = "/home/sewi/From\\ The\\ Depths/Player\\ Profiles/Ropianos/Constructables/"
let ftd_res = "/home/sewi/.local/share/Steam/steamapps/common/From\\ The\\ Depths/From_The_Depths_Data/StreamingAssets/"

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
  let regex = Str.regexp ".*\\.blueprint_backup" in
  let bp_files path =
    find ".*\\.blueprint" path
    |> List.map (fun path -> Str.split (Str.regexp "/") path |> List.rev |> List.hd, path)
    |> List.filter (fun (name,_) -> Str.string_match regex name 0 |> not)
    (* |> List.filter (fun str -> Str.string_match (Str.regexp "sample") str 0) *)
  in
  let try_vehicle_of_yojson (name,path) =
      Printf.printf "Reading >%s< at path >%s<\n" name path;
      Yojson.Safe.from_file path
    |> Ftd_rep.vehicle_of_yojson
    |> Option.some
  in
  let bp_safe = List.filter_map try_vehicle_of_yojson (bp_files ftd_res) in

  List.map (fun x -> x |> Ftd_rep.show_vehicle |> print_endline; print_endline "") bp_safe |> ignore;
  ()
  (*
  List.map (fun x -> x.blueprint.csi |> show_csi |> print_endline) bp_safe |> ignore;
  List.map (fun x -> [%yojson_of: string list option] x.blueprint.col |> Yo.show |> print_endline) bp_safe |> ignore;
   *  Yo.to_channel stdout fst.item_dictionary
   * *)

let _ =
  Printexc.record_backtrace true;
  try
    main ()
  with exn -> Printexc.print_backtrace stderr;
    match exn with
      Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error (exn, json) ->
       Printf.fprintf stderr "Exception:\n%s\n\nRelevant JSON:\n%s\n" (Printexc.to_string exn) (Yo.show json)
    | exn ->
      Printexc.to_string exn
      |> Printf.fprintf stderr "Exception:\n%s\n"
