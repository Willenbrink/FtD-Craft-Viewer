open Util
open Cli

let personal_cons = "~/From\\ The\\ Depths/Player\\ Profiles/Ropianos/Constructables/"

let bp_path = personal_cons
let bp_path = ftd_res

let try_parse parser (name,path) =
  try
    if !verbose >= 2 then Printf.printf "Reading >%s< at path >%s<\n" name path;
    Yojson.Safe.from_file path
    |> parser
    |> Option.some
  with Unsupported_Version v -> if !verbose >= 1 then Printf.printf "File %s uses unsupported version %s\n" name v; None

let try_and_count f xs =
  List.fold_left_map (fun acc x -> match f x with None -> (acc + 1,None) | Some x -> (acc,Some x)) 0 xs
  ||> List.filter_map Fun.id

let items () =
  get_files ".*\\\\.item$" ftd_res
  |> try_and_count (try_parse Item.item_of_yojson)

let constructs () =
  get_files ".*\\.blueprint$" bp_path
  |> try_and_count (try_parse Construct_ftd.parse_construct)

let%expect_test "Parsing items" =
  let (item_fails, _) = items () in
  print_int item_fails; [%expect{| 0 |}]

let%expect_test "Parsing constructs" =
  let (cons_fails, _) = constructs () in
  print_int cons_fails; [%expect{| 357 |}]

let rec compare_json node t u =
  match (t,u) with
   ((`Assoc _ as t), (`Assoc _ as u)) ->
  Yo.Util.(
    let keys_t = List.sort String.compare (keys t) in
    let keys_u = List.sort String.compare (keys u) in
    if List.compare String.compare keys_t keys_u != 0 then failwith (Printf.sprintf "Node: %s failed with keys:\n%s\n%s\n" node ([%show: string list] keys_t) ([%show: string list] keys_u));
    List.fold_left (fun acc kt -> acc && compare_json (node ^ kt) (member kt t) (member kt u)) true keys_t
  )
  | (x,y) -> Yo.equal x y

let%test "Construct: FtD <-> Internal" =
  let (_, cons) = constructs () in
  cons
  |> List.map (fun construct ->
      let cons = Construct_ftd.yojson_of_t construct in
      let cons' =
        construct
        |> Conversion.cons_int_of_ftd
        |> Conversion.cons_ftd_of_int
        |> Construct_ftd.yojson_of_t
      in
      if compare_json (construct.name |> Option.value ~default:"Unnamed") cons cons'
      then true
      else (Printf.printf "Incorrect conversion for original construct:\n%s\n\nand converted construct:\n%s\n" (Yo.show cons) (Yo.show cons'); raise Generic))
  |> List.fold_left (&&) true
