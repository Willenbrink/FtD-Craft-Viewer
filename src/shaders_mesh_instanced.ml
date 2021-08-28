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

let get_selection camera (blocks : (Block.t * Mesh.t * Matrix.t CArray.t) list) =
  if not @@ is_mouse_button_pressed MouseButton.Left
  then None
  else
    let ray = get_mouse_ray (get_mouse_position ()) camera in
    List.fold_left (fun acc (block, mesh, tfs) ->
        CArray.fold_left (fun acc transform ->
            let rayc = get_ray_collision_mesh ray mesh transform in
            if RayCollision.hit rayc
            then match acc with
              | None -> Some (block, mesh, transform, rayc)
              | Some (_,_,_,c) ->
                if RayCollision.distance rayc < RayCollision.distance c
                then Some (block, mesh, transform, rayc)
                else acc
            else acc
          ) acc tfs
      ) None blocks
  |> Option.map (fun (a,b,c,_) -> (a,b,c))

let main camera items (construct : Construct_int.t) =
  let ambient = Vector4.create 0.8 0.8 0.8 1.0 in
  let shader, update_view_pos = Shading.load_ambient "shader.vs" "shader.fs" ambient in

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

  let rec loop selection block_carrays =
    if window_should_close ()
    then close_window ()
    else begin
      update_camera (addr camera);

      let cpos = Camera3D.position camera in
      Vector3.(create (x cpos) (y cpos) (z cpos))
      |> update_view_pos;

      begin_drawing ();
      clear_background Color.raywhite;
      begin_mode_3d camera;

      let rot_of_key key = Key.(match key with
          | W -> (1.0,0.0,0.0)
          | S -> (-1.0,0.0,0.0)
          | A -> (0.0,1.0,0.0)
          | D -> (0.0,-1.0,0.0)
          | Q -> (0.0,0.0,1.0)
          | E -> (0.0,0.0,-1.0)
          | _ -> (0.0,0.0,0.0)
        ) |> (fun (a,b,c) -> let f = 2.0 /. Float.pi in let f = 1.0 in (a /. f, b /. f, c /. f))
      in
      let pressed_keys options = List.filter is_key_pressed options in

      let block_carrays =
        let keys = pressed_keys Key.[A;D;Q;E;W;S] in
        if keys == [] && not (is_key_pressed Key.Space)
        then block_carrays
        else
          (if is_key_pressed Key.Space
           then List.map (fun (block, mesh, transforms, trans, rots) ->
               block, mesh, transforms, trans, CArray.map Matrix.t (fun _ -> Matrix.identity ()) rots
             ) block_carrays
           else
             let rot =
               List.map rot_of_key keys
               |> List.fold_left (fun (a,b,c) (d,e,f) -> (a+.d, b+.e, c+.f)) (0.0,0.0,0.0)
               |> (fun (a,b,c) -> Matrix.rotate (Vector3.create a b c) (Float.pi /. 2.0))
             in
             List.map (fun (block, mesh, transforms, trans, rots) ->
                 (block, mesh, transforms,
                  trans, CArray.map Matrix.t (fun m -> Matrix.multiply m rot) rots
                 )
               ) block_carrays
          )
          |> List.map (fun (block, mesh,tf,trans,rots) ->
              (block, mesh, CArray.mapi Matrix.t (fun i _ -> Matrix.multiply (CArray.get rots i) (CArray.get trans i)) tf,
               trans, rots
              )
            )
      in
      let block_tfs = List.map (fun (a,b,c,_,_) -> (a,b,c)) block_carrays in
      (* let selection = match get_selection camera block_tfs with
       *   | None -> selection
       *   | x -> Printf.printf "Object selected\n"; x
       * in *)

      List.iter (fun (block, mesh, matrices) ->
          draw_mesh_instanced
            mesh mat_default
            (CArray.start matrices) (CArray.length matrices)
        ) block_tfs;
      (match selection with
       | None -> ()
       | Some (block, mesh, tf) ->
         let ptr = Ctypes.allocate Matrix.t tf in
         draw_mesh_instanced mesh mat_sel ptr 1);

      end_mode_3d ();

      draw_fps 10 10;
      end_drawing ();
      flush_all ();
      loop selection block_carrays
    end
  in

  let block_carrays = fold_bp (fun xs x -> x :: xs) [] construct.blueprint |> List.concat in
  List.map (fun (x,y,z) -> (x, y, z, CArray.copy z,
                          CArray.map Matrix.t (fun _ -> Matrix.identity ()) z
                         )) block_carrays
  |> loop None
