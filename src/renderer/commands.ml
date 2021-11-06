open Rlights
open Ftd_parser
open Raylib
open Util_renderer

let handle_rotation_key ((construct : Construct_int.t), selection) block_carrays =
  let rot_of_key key =
    let open Rotation in
    Key.(match key with
        | W -> rot X 1
        | S -> rot X 3
        | A -> rot Y 1
        | D -> rot Y 3
        | Q -> rot Z 1
        | E -> rot Z 3
        | _ -> rot X 0
      )
  in
  let pressed_keys options = List.filter is_key_pressed options in

  let keys = pressed_keys Key.[A;D;Q;E;W;S] in
  if keys == [] && not (is_key_pressed Key.Space)
  then block_carrays
  else
    (if is_key_pressed Key.Space
     then List.map (fun (id, mesh, is, transforms, trans, rots) ->
         id, mesh, is, transforms, trans,
         CArray.map Matrix.t (fun _ -> Matrix.identity ()) rots
       ) block_carrays
     else
       let rot =
         List.map rot_of_key keys
         |> List.fold_left Rotation.( * ) (Matrix.identity ())
       in
       List.map (fun (id, mesh, is, transforms, trans, rots) ->
           let bp = find_bp id construct.bp in
           let selection_rot = match selection with None -> -1 | Some (index,_,_) -> (find_block construct index : Block.t).rot |> fst in
           (id, mesh, is, transforms, trans,
            CArray.mapi Matrix.t (fun i m -> if bp.blocks.(is.(i)).rot |> fst = selection_rot then Matrix.multiply m rot else m) rots
           )
         ) block_carrays
    )
    |> List.map (fun (id, mesh, is, transforms, trans, rots) ->
        (id, mesh, is,
         CArray.mapi Matrix.t (fun i _ -> Matrix.multiply (CArray.get rots i) (CArray.get trans i)) transforms,
         trans, rots
        )
      )
