open Raylib
open Util

type axis = X | Y | Z

let rot axis d =
  let a,b,c = match axis with
    | X -> 1,0,0
    | Y -> 0,1,0
    | Z -> 0,0,1
  in
  Matrix.rotate (Vector3.create
                          (float_of_int a)
                          (float_of_int b)
                          (float_of_int c))
    ((float_of_int d) *. (Float.pi /. 2.0))

let ( * ) = Matrix.multiply

type t = int * Matrix.t [@@deriving show]
let of_int t = t,(match t with
  | 0 -> rot X 0
  | 1 -> rot X 0 * rot Y 3
  | 2 -> rot Y 2
  | 3 -> rot Z 0 * rot Y 1
  | 4 -> rot X 1 * rot Y 0
  | 5 -> rot Z 2 * rot X 3 * rot Y 1 * rot Z 2
  | 6 -> rot X 1 * rot Y 2
  | 7 -> rot Y 1 * rot Z 3
  | 8 -> rot Z 2 * rot X 3 * rot Y 0
  | 9 -> rot X 3 * rot Y 1
  | 10 -> rot Z 2 * rot X 3 * rot Y 2
  | 11 -> rot X 3 * rot Y 3
  | 12 -> rot Z 2 * rot Y 0
  | 13 -> rot Y 2 * rot Z 2 * rot Y 1
  | 14 -> rot Z 2 * rot Y 2
  | 15 -> rot Z 2 * rot X 2 * rot Z 2 * rot Y 3
  | 16 -> rot Z 1
  | 17 -> rot Z 3 * rot Y 2
  | 18 -> rot Z 3
  | 19 -> rot Z 1 * rot Y 2
  | 20 -> rot X 2 * rot Z 3 * rot Y 1
  | 21 -> rot X 2 * rot Z 1 * rot Y 3
  | 22 -> rot X 2 * rot Z 1 * rot Y 1
  | 23 -> rot X 2 * rot Z 3 * rot Y 3
  | _ -> rot X 0)

let int_of t = fst t
