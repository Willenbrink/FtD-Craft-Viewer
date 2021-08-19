open Ftd_parser
open Util
open Cli
open Main

let parse () =
  let (item_fails, items) = if !read_items || !print_items then items () |>> Option.some ||> Option.some else (None,None) in
  let (cons_fails, cons) = if !read_cons || !print_cons then constructs () |>> Option.some ||> Option.some else (None,None) in
  (match items with
    Some items -> if !print_items then List.iter (fun x -> x |> Item.show_item |> print_endline; print_endline "") items
   | None -> ());
  (match cons with
    Some cons -> if !print_cons then List.iter (fun x -> x |> Construct_ftd.show |> print_endline; print_endline "") cons
   | None -> ());
  (match item_fails with
     Some i -> Printf.printf "Failed to parse %i items.\n" i
   | None -> ());
  (match cons_fails with
     Some i -> Printf.printf "Failed to parse %i constructs.\n" i
   | None -> ())

let get_construct path =
  try_parse Construct_ftd.t_of_yojson ("CLI", path)
  |> Option.get
  |> Conversion.cons_int_of_ftd

let init () =
  let open Raylib in
  init_window 800 450 "Unto the Beach";
  set_window_state ConfigFlags.[ Window_resizable; Msaa_4x_hint; ];
  set_target_fps 6;

  let cam =
    Camera.create
      (Vector3.create 10.0 10.0 10.0)
      (Vector3.create 0.0 0.0 0.0)
      (Vector3.create 0.0 1.0 0.0)
      65.0
      CameraProjection.Perspective
  in
  set_camera_mode cam CameraMode.Free;
  cam

let render cube mat (construct : Construct_internal.t) =
  let open Raylib in
  let blocks =
    List.concat_map Array.to_list (Construct_internal.blocks construct)
    |> List.map (fun (b : Block.t) -> let x,y,z = b.pos in
                  Matrix.translate
                    (float_of_int x)
                    (float_of_int y)
                    (float_of_int z)
                )
  in
  let carray = CArray.of_list Matrix.t blocks in
  draw_mesh_instanced cube mat (CArray.start carray) (CArray.length carray);
  let pos_v = Vector3.create 0.0 0.0 0.0 in
  let transl = Matrix.translate 0.0 0.0 0.0 in
  draw_mesh cube mat transl

let rec loop camera items construct =
  match Raylib.window_should_close () with
  | true -> Raylib.close_window ()
  | false ->
    let open Raylib in

    let cube = gen_mesh_cube 10.0 10.0 10.0 in
    let shader = load_shader "shader.vs" "" in
    (* if Ctypes.getf shader Types.Shader.id = Unsigned.UInt.zero
     * then failwith "Shader failed to compile"; *)
    (* let mvp = get_shader_location shader "mvp" in *)
    (* let view_pos = get_shader_location shader "viewPos" in *)
    (* let instance = get_shader_location shader "instance" in *)
    (* let ambient = get_shader_location shader "ambient" in *)

    (* let ambient_vec = Vecor4.create 0.2 0.2 0.2 1.0 in
     * set_shader_value shader ambient (to_voidp (addr ambient_vec)) ShaderUniformDataType.Vec4; *)

    (* Get the locs array and assign the locations of the variables. This is necessary for the draw_mesh_instanced call.
     * Curiously, draw_mesh works without setting these. *)
    (* let locs = Shader.locs shader in *)
    (* CArray.set locs ShaderLocationIndex.(Matrix_mvp |> to_int) mvp; *)
    (* CArray.set locs ShaderLocationIndex.(Matrix_model |> to_int) instance; *)
    (* CArray.set locs ShaderLocationIndex.(Vector_view |> to_int) view_pos; *)

    let mat = load_material_default () in
    Material.set_shader mat shader;
    MaterialMap.set_color (CArray.get (Material.maps mat) 0) Color.red;

    (* let cpos = Vector3.create 0.0 0.0 0.0 in
     * let pos = Vector3.(create (x cpos) (y cpos) (z cpos)) in
     * set_shader_value (Material.shader mat) view_pos (pos |> addr |> to_voidp) ShaderUniformDataType.Vec3; *)




    update_camera (addr camera);
    begin_drawing ();
    clear_background Color.white;
    begin_mode_3d camera;
    draw_grid 20 10.0;
    begin_shader_mode shader;
    render cube mat construct;
    end_shader_mode ();
    end_mode_3d ();
    end_drawing ();
    loop camera items construct

let () =
  Printexc.record_backtrace true;
  Arg.parse spec (fun _ -> raise Generic) "";
  try

    let start = Sys.time () in
    !path
    |> get_construct
    |> Shaders_mesh_instanced.main;
    let stop = Sys.time () in
    Printf.printf "Executed in %fs\n" (stop -. start)
  with exn -> Printexc.print_backtrace stdout;
    match exn with
      Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error (exn, json) ->
       Printf.printf "Exception:\n%s\n\nRelevant JSON:\n%s\n" (Printexc.to_string exn) (Yo.show json)
    | exn ->
      Printexc.to_string exn
      |> Printf.printf "Exception:\n%s\n"
