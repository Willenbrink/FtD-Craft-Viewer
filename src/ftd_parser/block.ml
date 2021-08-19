open Util

type t = {
  id : int;
  pos : v3i;
  rot : Rotation.t;
  color : int;
  typ : Common.guid;
} [@@deriving show]
