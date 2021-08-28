open Util

type t = {
  id : int;
  pos : v3i;
  rot : Rotation.t;
  color : int;
  typ : Item_int.t
        [@printer fun fmt (t : Item_int.t) ->
          fprintf fmt "%s-%s"
            t.component_id.name
            (t.component_id.guid |> Common.Guid.show)];
} [@@deriving show]
