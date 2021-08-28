open Rlights
open Ftd_parser
open Raylib
open Util_renderer

let width = 800
let height = 450

let init_raylib () =
  set_config_flags [ ConfigFlags.Msaa_4x_hint; ConfigFlags.Window_resizable ];
  init_window width height "Unto the Beach";

  let position = Vector3.create 25.0 25.0 25.0 in
  let target = Vector3.create 0.0 0.0 0.0 in
  let up = Vector3.create 0.0 1.0 0.0 in
  let camera = Camera.create position target up 65.0 CameraProjection.Perspective in

  set_camera_mode camera CameraMode.Free;

  set_target_fps 60;
  camera

let[@landmark] get_selection camera (blocks : (int * Block.t * int array
                                               * Matrix.t CArray.t
                                               * Matrix.t CArray.t
                                               * Matrix.t CArray.t
                                              ) list) =
  if not @@ is_mouse_button_pressed MouseButton.Left
  then None
  else
    let ray = get_mouse_ray (get_mouse_position ()) camera in

    List.fold_left (fun acc (i, (block : Block.t), is, ms, _, _) ->
        CArray.fold_left (fun (j,acc) matrix ->
            let rayc = get_ray_collision_mesh ray block.typ.mesh.mesh matrix in
            let acc =
              let index = i, is.(j) in
              if RayCollision.hit rayc
              then match acc with
                | None -> Some (index, block, j, rayc)
                | Some (_,_,_,c) ->
                  if RayCollision.distance rayc < RayCollision.distance c
                  then Some (index, block, j, rayc)
                  else acc
              else acc
            in
            (j+1,acc)
(* The initial index is 0 as we reversed the carray compared to blocks
 *  while building it in Construct_int.bp_int_of_ftd *)
          ) (0, acc) ms
      |> snd
    |> Option.map (fun (a,b,c,d) -> (a,b, c,d))
      ) None blocks
  |> Option.map (fun (index,mesh,matrix,collision) -> index,mesh,matrix)

let main camera items (construct : Construct_int.t) =
  let ambient = Vector4.create 0.8 0.8 0.8 1.0 in
  let shader, update_view_pos = Shading.load_ambient "shader.vs" "shader.fs" ambient in
  let handle_camera () =
    update_camera (addr camera);
    let cpos = Camera3D.position camera in
    Vector3.(create (x cpos) (y cpos) (z cpos))
    |> update_view_pos
  in

  let[@landmark] handle_rotation_key selection block_carrays =
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
  in

  let blocks : Block.t list = List.concat_map Array.to_list (Construct_int.blocks construct) in
  let count = List.length blocks in
  Printf.printf "Vehicle has %i blocks.\n" count;

  create_light Directional (Vector3.create 50.0 50.0 0.0) (Vector3.zero ()) Color.white shader |> ignore;

  let mat_default = load_material_default () in
  Material.set_shader mat_default shader;
  MaterialMap.set_color (CArray.get (Material.maps mat_default) 0) Color.gray;

  let mat_sel = load_material_default () in
  Material.set_shader mat_sel shader;
  MaterialMap.set_color (CArray.get (Material.maps mat_sel) 0) Color.red;

  let[@landmark] draw_block_carrays block_carrays =
    List.iter (fun (_, (block : Block.t), _, matrices, _, _) ->
        draw_mesh_instanced
          block.typ.mesh.mesh mat_default
          (CArray.start matrices) (CArray.length matrices)
      ) block_carrays
  in

  let[@landmark] draw_selection blocks_carray = function
       | None -> ()
       | Some (index, (block : Block.t), i) ->
         let bp : Construct_int.bp = find_bp (index |> fst) construct.bp in
         (* Printf.printf "%s - %i\n" ([%show: int * int] index) i; *)
         let _,_,_,blocks_carray,_,_ = List.find (fun (id,(b : Block.t),_,_,_,_) -> bp.id = id && b.id = block.id) blocks_carray in
         let ptr = Ctypes.(+@) (CArray.start blocks_carray) i in
         draw_mesh_instanced block.typ.mesh.mesh mat_sel ptr 1
  in

  let [@landmark] rec loop selection
      (block_carrays : (int * Block.t * int array
                        * Matrix.t CArray.t
                        * Matrix.t CArray.t
                        * Matrix.t CArray.t
                       ) list) =
    if window_should_close ()
    then close_window ()
    else begin
      handle_camera ();

      begin_drawing ();
      clear_background Color.raywhite;
      begin_mode_3d camera;

      let block_carrays = handle_rotation_key selection block_carrays in

      let selection = match get_selection camera block_carrays with
        | None -> selection
        | (Some (index,_,_) as res) ->
          Printf.printf "Block selected:\n%s\n"
            (Block.show (find_block construct index)); res
      in

      draw_block_carrays block_carrays;
      draw_selection block_carrays selection;

      end_mode_3d ();

      draw_fps 10 10;
      end_drawing ();
      flush_all ();
      loop selection block_carrays
    end
  in

  let block_carrays =
    fold_bp (fun xs (x : Construct_int.bp) -> x.blocks_carray :: xs) [] construct.bp
    |> List.concat
  in
  List.map (fun (id, m, is, ms) -> (id, m, is, CArray.copy ms, CArray.copy ms,
                          CArray.map Matrix.t (fun _ -> Matrix.identity ()) ms
                         )) block_carrays
  |> loop None
