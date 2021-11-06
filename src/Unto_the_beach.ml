open Ftd_parser
open Util
open State

let force conds resource =
  if List.fold_left (fun acc cond -> acc || cond ()) false conds
  then Lazy.force resource |>> Option.some ||> Option.some
  else (None,None)

let show_res cond res printer =
  match res with
  | None -> ()
  | Some res ->
    if cond ()
    then List.iter (fun x -> (printer x ^ "\n") |> print_endline) res

let parse () =
  let open State in
  let open Resources in
  let (item_fails, items) = force [read_items; print_items] items in
  let (cons_ftd_fails, cons_ftd) = force [read_cons; print_cons] constructs_ftd in
  let (cons_pers_fails, cons_pers) = force [read_cons; print_cons] constructs_personal in
  show_res print_items items Item_int.show;
  show_res print_cons cons_ftd Construct_int.show;
  show_res print_cons cons_pers Construct_int.show;
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
  State.init (fun () ->
      let start = Sys.time () in
      let cam = Renderer.init_raylib () in
      let meshes = Lazy.force Resources.meshes in
      let items = Lazy.force Resources.items |> snd in
      State.path ()
      |> get_construct
      |> Renderer.main cam items;
      let stop = Sys.time () in
      Printf.printf "Executed in %fs\n" (stop -. start))
    (fun exn -> Printexc.print_backtrace stdout;
      match exn with
      | Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error (exn, json) ->
        Printf.printf "Exception:\n%s\n\nRelevant JSON:\n%s\n" (Printexc.to_string exn) (Yo.show json)
      | exn ->
        Printexc.to_string exn
        |> Printf.printf "Exception:\n%s\n")
