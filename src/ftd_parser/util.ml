(* Helpful regex: s/ \(\w*\)/  \1 : Yo.t [@key "\1"];\n/g *)

type blank = {
  x : int;
} [@@deriving show, yojson]

module Yo = struct
  include Yojson.Safe

  let t_of_yojson x = x
  let yojson_of_t x = x
end

let yoscanf t fmt fn = Scanf.sscanf ([%of_yojson: string] t) fmt fn

module Gg = struct
  include Gg
  let pp_v3 = V3.pp
  let v3_of_yojson t = yoscanf t "%f,%f,%f" V3.v
  let yojson_of_v3 t = `String V3.(Printf.sprintf "%f,%f,%f" (x t) (y t) (z t))
  let%test "v3" =
    let v = V3.v 0.1 0.2 0.3 in
    (v |> yojson_of_v3 |> v3_of_yojson) = v

  let pp_v4 = V4.pp
  let v4_of_yojson t = yoscanf t "%f,%f,%f,%f" V4.v
  let yojson_of_v4 t = `String V4.(Printf.sprintf "%f,%f,%f,%f" (x t) (y t) (z t) (w t))
  let%test "v4" =
    let v = V4.v 0.1 0.2 0.3 0.4 in
    (v |> yojson_of_v4 |> v4_of_yojson) = v

  type v3i = (int * int * int) [@@deriving show]
  let v3i_of_yojson t = yoscanf t "%i,%i,%i" (fun a b c -> a,b,c)
  let yojson_of_v3i (a,b,c) = `String (Printf.sprintf "%i,%i,%i" a b c)
  let%test "v3i" =
    let v = (1,2,3) in
    (v |> yojson_of_v3i |> v3i_of_yojson) = v

  type v4i = (int * int * int) [@@deriving show]
  let v4i_of_yojson t = yoscanf t "%i,%i,%i,%i" (fun a b c d -> a,b,c,d)
  let yojson_of_v4i (a,b,c,d) = `String (Printf.sprintf "%i,%i,%i,%i" a b c d)
  let%test "v4i" =
    let v = (1,2,3,4) in
    (v |> yojson_of_v4i |> v4i_of_yojson) = v

end
include Gg

module Either = struct
  include Either
  type ('a,'b) t = ('a,'b) Either.t = Left of 'a | Right of 'b [@@deriving show]
end

module Matrix = struct
  include Raylib.Matrix
  let pp fmt t = Format.fprintf fmt "[%f,%f,%f,%f;%f,%f,%f,%f;%f,%f,%f,%f;%f,%f,%f,%f;]"
      (m0 t) (m1 t) (m2 t) (m3 t)
      (m4 t) (m5 t) (m6 t) (m7 t)
      (m8 t) (m9 t) (m10 t) (m11 t)
      (m12 t) (m13 t) (m14 t) (m15 t)

  let pp fmt t = Format.fprintf fmt "\n[%i,%i,%i,%i\n;%i,%i,%i,%i\n;%i,%i,%i,%i\n;%i,%i,%i,%i;]"
      (m0 t |> int_of_float) (m1 t |> int_of_float) (m2 t |> int_of_float) (m3 t |> int_of_float)
      (m4 t |> int_of_float) (m5 t |> int_of_float) (m6 t |> int_of_float) (m7 t |> int_of_float)
      (m8 t |> int_of_float) (m9 t |> int_of_float) (m10 t |> int_of_float) (m11 t |> int_of_float)
      (m12 t |> int_of_float) (m13 t |> int_of_float) (m14 t |> int_of_float) (m15 t |> int_of_float)
end

let (|>>) (a,b) f = (f a,b)
let (||>) (a,b) f = (a,f b)

exception Generic
exception Invariant_violated of string
exception Unsupported_Version of string

let check name f x =
  if !Cli.check_invars
  then
    if f x
    then x
    else raise (Invariant_violated name)
  else x

let list_of_path path = String.split_on_char '/' path

let tap f x = f x; x

let flip (x,y,z) = (-x,y,z)
