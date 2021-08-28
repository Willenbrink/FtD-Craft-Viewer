open Ftd_parser
open Util
open Cli

let parse () =
  let (item_fails, items) =
    if !read_items || !print_items
    then Lazy.force Resources.items |>> Option.some ||> Option.some
    else (None,None)
  in
  let (cons_ftd_fails, cons_ftd) =
    if !read_cons || !print_cons
    then Lazy.force Resources.constructs_ftd |>> Option.some ||> Option.some
    else (None,None)
  in
  let (cons_pers_fails, cons_pers) =
    if !read_cons || !print_cons
    then Lazy.force Resources.constructs_personal |>> Option.some ||> Option.some
    else (None,None)
  in
  (* (match items with
   *    Some items ->
   *    if !print_items
   *    then List.iter (fun x -> x |> Item_int.show |> print_endline; print_endline "") items
   *  | None -> ()); *)
  (match cons_ftd with
     Some cons ->
     if !print_cons
     then List.iter (fun x -> x |> Construct_int.show |> print_endline; print_endline "") cons
   | None -> ());
  (match cons_pers with
     Some cons ->
     if !print_cons
     then List.iter (fun x -> x |> Construct_int.show |> print_endline; print_endline "") cons
   | None -> ());
  (match item_fails with
     Some i ->
     Printf.printf "Failed to parse items:\n";
     [%show: int * string list] i
     |> print_endline
   | None -> ());
  (match cons_ftd_fails with
     Some i ->
     Printf.printf "Failed to parse construct_ftds:\n";
     [%show: int * string list] i
     |> print_endline
   | None -> ());
  (match cons_pers_fails with
     Some i ->
     Printf.printf "Failed to parse construct_personals:\n";
     [%show: int * string list] i
     |> print_endline
   | None -> ())

let get_construct path =
  Resources.try_parse
    (Construct_int.parse
       Resources.item_res
       Resources.mesh_res
    ) ("CLI", path)
  |> (function Left x -> x
             | Right x -> failwith x)

(* let get_construct name =
 *   (Lazy.force Resources.constructs_ftd) @ (Lazy.force Resources.constructs_personal)
 * |> List.find (fun (c : Construct_int.))
 *   ;
 *   Resources.try_parse (Construct_int.parse (Lazy.force Resources.items |> snd)) ("CLI", path)
 *   |> Either.find_left
 *   |> Option.get *)

let () =
  Printexc.record_backtrace true;
  Arg.parse spec (fun _ -> raise Generic) "";
  try
    let start = Sys.time () in
    let cam = Shaders_mesh_instanced.init_raylib () in
    let meshes = Lazy.force Resources.meshes in
    let items = Lazy.force Resources.items |> snd in
    !path
    |> get_construct
    |> Shaders_mesh_instanced.main cam items;
    let stop = Sys.time () in
    Printf.printf "Executed in %fs\n" (stop -. start)
  with exn -> Printexc.print_backtrace stdout;
    match exn with
      Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error (exn, json) ->
       Printf.printf "Exception:\n%s\n\nRelevant JSON:\n%s\n" (Printexc.to_string exn) (Yo.show json)
    | exn ->
      Printexc.to_string exn
      |> Printf.printf "Exception:\n%s\n"
