open Ftd_parser

let rec iter_bp f (bp : Construct_int.bp) =
  List.iter (iter_bp f) bp.scs;
  f bp
let rec map_bp f (bp : Construct_int.bp) =
  let scs = List.map (map_bp f) bp.scs in
  f {bp with scs}
let rec fold_bp f acc (bp : Construct_int.bp) =
  let acc = f acc bp in
  let acc = List.fold_left (fold_bp f) acc bp.scs in
  acc

exception Found of Construct_int.bp
let find_bp id bp =
  try
    fold_bp (fun acc (bp : Construct_int.bp) -> if bp.id = id then raise (Found bp) else acc) None bp
    |> ignore;
    raise Not_found
  with Found bp -> bp

let find_block (construct : Construct_int.t) (i,j) = (find_bp i construct.bp : Construct_int.bp).blocks.(j)
