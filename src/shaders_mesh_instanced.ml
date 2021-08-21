open Rlights
open Ftd_parser

let width = 800
let height = 450

let init_raylib () =
  let open Raylib in
  set_config_flags [ ConfigFlags.Msaa_4x_hint; ConfigFlags.Window_resizable ];
  init_window width height "Unto the Beach";

  let position = Vector3.create 125.0 125.0 125.0 in
  let target = Vector3.create 0.0 0.0 0.0 in
  let up = Vector3.create 0.0 1.0 0.0 in
  let camera = Camera.create position target up 65.0 CameraProjection.Perspective in

  set_camera_mode camera CameraMode.Free;

  set_target_fps 60;
  camera

let main items (construct : Construct_int.t) =
  let camera = init_raylib () in
  let ambient = Raylib.Vector4.create 0.8 0.8 0.8 1.0 in
  let shader, update_view_pos = Shader.load_ambient "shader.vs" "shader.fs" ambient in
  let open Raylib in

  let cube = gen_mesh_cube 1.0 1.0 1.0 in

  let matrix_rotation _ = Matrix.rotate (Vector3.zero ()) 0.0 in

  (* draw_mesh_instanced takes a ptr. CArrays can be instantly cast to/from ptrs *)
  let blocks : Block.t list = List.concat_map Array.to_list (Construct_int.blocks construct) in
  let count = List.length blocks in
  let translations = CArray.from_ptr (Ctypes.allocate_n Matrix.t ~count) count in
  let rotations = CArray.from_ptr (Ctypes.allocate_n Matrix.t ~count) count in
  Printf.printf "Vehicle has %i blocks.\n" count;
  List.iteri (fun i (b : Block.t) -> let x,y,z = b.pos in CArray.set translations i (
      Matrix.translate
        (float_of_int x)
        (float_of_int y)
        (float_of_int z)
    );
    CArray.set rotations i (matrix_rotation i)
    ) blocks;

  create_light Directional (Vector3.create 50.0 50.0 0.0) (Vector3.zero ()) Color.white shader |> ignore;

  let material = load_material_default () in
  Material.set_shader material shader;
  MaterialMap.set_color (CArray.get (Material.maps material) 0) Color.red;

  while not (Raylib.window_should_close ())
  do
    update_camera (addr camera);

    let cpos = Camera3D.position camera in
    Vector3.(create (x cpos) (y cpos) (z cpos))
    |> update_view_pos;

    begin_drawing ();
    clear_background Color.raywhite;
    begin_mode_3d camera;

    draw_mesh_instanced cube material (CArray.start translations) count;

    end_mode_3d ();

    draw_fps 10 10;
    end_drawing ()

  done;
  Raylib.close_window ()
