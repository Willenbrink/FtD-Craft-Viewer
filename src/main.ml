open Util
open Cli

let personal_cons = "~/From\\ The\\ Depths/Player\\ Profiles/Ropianos/Constructables/"

let bp_path = personal_cons
let bp_path = ftd_res

let try_parse parser (name,path) =
  try
    if !verbose then Printf.printf "Reading >%s< at path >%s<\n" name path;
    Yojson.Safe.from_file path
    |> parser
    |> Option.some
  with Unsupported_Version v -> if !verbose then Printf.printf "File %s uses unsupported version %s\n" name v; None

let try_and_count f xs =
  List.fold_left_map (fun acc x -> match f x with None -> (acc + 1,None) | Some x -> (acc,Some x)) 0 xs
  ||> List.filter_map Fun.id

let items () =
  get_files ".*\\\\.item$" ftd_res
  |> try_and_count (try_parse Item.item_of_yojson)

let constructs () =
  get_files ".*\\.blueprint$" bp_path
  |> try_and_count (try_parse Ftd_rep.parse_construct)

let rec compare_json t u =
  Yo.Util.(
    let keys_t = keys t in
    let keys_u = keys u in
    if keys_t != keys_u then raise Generic;
    List.fold_left2 (fun acc kt ku -> acc && compare_json (member kt t) (member ku u)) true keys_t keys_u
  )

let%expect_test "Parsing items" =
  let (item_fails, items) = items () in
  print_int item_fails; [%expect{| 0 |}]

let%expect_test "Parsing constructs" =
  let (cons_fails, cons) = constructs () in
  print_int cons_fails; [%expect{| 357 |}]

let%test "Construct: FtD <-> Internal" =
  let (cons_fails, cons) = constructs () in
  cons
  |> List.map (fun construct ->
      let cons = Ftd_rep.yojson_of_construct construct in
      let cons' = construct |> Int_rep.internal_of_construct |> Int_rep.construct_of_internal |> Ftd_rep.yojson_of_construct in
      if Yo.equal cons cons'
      then true
      else (Printf.printf "Incorrect conversion for original construct:\n%s\n\nand converted construct:\n%s\n" (Yo.show cons) (Yo.show cons'); raise Generic))
  |> List.fold_left (&&) true
