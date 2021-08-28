type axis = X | Y | Z

let rot axis d =
  let a,b,c = match axis with
    | X -> 1,0,0
    | Y -> 0,1,0
    | Z -> 0,0,1
  in
  Raylib.Matrix.rotate (Raylib.Vector3.create
                          (float_of_int a)
                          (float_of_int b)
                          (float_of_int c))
    ((float_of_int d) *. (Float.pi /. 2.0))

let ( *) = Raylib.Matrix.multiply

type t = Raylib.Matrix.t [@printer fun fmt _ -> fprintf fmt "<opaque>"] [@@deriving show]
let of_int t = match t with
  | 0 -> rot X 0
  | 1 -> rot Y 1
  | 2 -> rot Y 2
  | 3 -> rot Y 3
  | 4 -> rot X 1 * rot Y 0
  | 5 -> rot X 1 * rot Y 1
  | 6 -> rot X 1 * rot Y 2
  | 7 -> rot X 1 * rot Y 3
  | 8 -> rot X 3 * rot Y 0
  | 9 -> rot X 3 * rot Y 1
  | 10 -> rot X 3 * rot Y 2
  | 11 -> rot X 3 * rot Y 3
  | 12 -> rot Z 2 * rot Y 0
  | 13 -> rot Z 2 * rot Y 1
  | 14 -> rot Z 2 * rot Y 2
  | 15 -> rot Z 2 * rot Y 3
  | 16 -> rot Z 1
  | 17 -> rot Z 1 * rot Y 2
  | 18 -> rot Z 3
  | 19 -> rot Z 3 * rot Y 2
  | 20 -> rot Z 3 * rot Y 1
  | 21 -> rot Z 1 * rot Y 3
  | 22 -> rot Z 1 * rot Y 1
  | 23 -> rot Z 3 * rot Y 3


  | 16 -> rot X 0
  | 22 -> rot X 0
  | 19 -> rot X 0
  | 21 -> rot X 0
    (* Rot RR *)
  | 12 -> rot X 0
  | 13 -> rot X 0
  | 14 -> rot X 0
  | 15 -> rot X 0
    (* Rot RRR *)
  | 18 -> rot X 0
  | 20 -> rot X 0
  | 17 -> rot X 0
  | 23 -> rot X 0

let int_of t = failwith "TODO int_of_rotation"
