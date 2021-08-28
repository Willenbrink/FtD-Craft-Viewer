open Util

type t = {
  id : int;
  pos : v3i;
  rot : Rotation.t;
  color : int;
  typ : Item_int.t;
} [@@deriving show]
