open Util

let unresolved_refs = ref []

let unresolved str r =
  if List.mem r !unresolved_refs
  then ()
  else
    (unresolved_refs := r :: !unresolved_refs;
     if State.verbose () >= 1
     then Printf.printf "%s reference %s unresolved\n" str ([%show: Common.Guid.t] r)
    )


let resolve_mesh_ref meshes (r : Common.Guid.t) =
  match List.find_opt (fun (mesh : Mesh_int.t) -> mesh.component_id.guid = r) meshes with
  | None ->
    (unresolved "Mesh" r;
    Lazy.force Mesh_int.mesh_default)
  | Some mesh -> mesh

let resolve_item_ref items (r : Common.Guid.t) =
  match List.find_opt (fun (item : Item_int.t) -> item.component_id.guid = r) items with
  | None ->
    (unresolved "Item" r;
     raise (Invariant_violated "Item unresolved!"))
    (* Either.Right r) *)
  | Some x -> x
