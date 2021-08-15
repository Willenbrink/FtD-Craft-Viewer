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

  let pp_v4 = V4.pp
  let v4_of_yojson t = yoscanf t "%f,%f,%f,%f" V4.v
  let yojson_of_v4 t = `String V4.(Printf.sprintf "%f,%f,%f,%f" (x t) (y t) (z t) (w t))

  type v3i = (int * int * int) [@@deriving show]
  let v3i_of_yojson t = yoscanf t "%i,%i,%i" (fun a b c -> a,b,c)
  let yojson_of_v3i (a,b,c) = `String (Printf.sprintf "%i,%i,%i" a b c)

  type v4i = (int * int * int) [@@deriving show]
  let v4i_of_yojson t = yoscanf t "%i,%i,%i,%i" (fun a b c d -> a,b,c,d)
  let yojson_of_v4i (a,b,c,d) = `String (Printf.sprintf "%i,%i,%i,%i" a b c d)

end
include Gg

let (|>>) (a,b) f = (f a,b)
let (||>) (a,b) f = (a,f b)

exception Generic
exception Invariant_violated
exception Unsupported_Version of string

let check f x = if !Cli.check_invars then if f x then x else raise Invariant_violated else x
