open Util

type rotation =
    Forward
  | Back
  | Right
  | Left
  | Up
  | Down
  | Unknown of int
[@@deriving show]
let rotation_of_yojson t = match [%of_yojson: int] t with
  | 0 -> Forward
  | 1 -> Right
  | 2 -> Back
  | 3 -> Left
  | 4 -> Down
  | 8 -> Up
    (* Rot R *)
  | 16 -> Forward
  | 22 -> Right
  | 19 -> Back
  | 21 -> Left
  | 5 -> Down
  | 9 -> Up
    (* Rot RR *)
  | 12 -> Forward
  | 13 -> Right
  | 14 -> Back
  | 15 -> Left
  | 6 -> Down
  | 10 -> Up
    (* Rot RRR *)
  | 18 -> Forward
  | 20 -> Right
  | 17 -> Back
  | 23 -> Left
  | 7 -> Down
  | 11 -> Up
  | x -> Printf.fprintf stderr "Unknown rotation: %i.\n" x; Unknown x
