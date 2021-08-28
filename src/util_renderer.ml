open Ftd_parser

let rec iter_bp f (bp : Construct_int.bp) =
  List.iter (iter_bp f) bp.scs;
  List.iter f bp.blocks_carray
let rec map_bp f (bp : Construct_int.bp) =
  let scs = List.map (map_bp f) bp.scs in
  let blocks_carray = List.map f bp.blocks_carray in
  {bp with scs; blocks_carray;}
let rec fold_bp f acc (bp : Construct_int.bp) =
  let acc = f acc bp.blocks_carray in
  let acc = List.fold_left (fold_bp f) acc bp.scs in
  acc
