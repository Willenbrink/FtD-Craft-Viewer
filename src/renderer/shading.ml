open Raylib

let set_view_pos shader view_pos pos =
    set_shader_value shader view_pos (pos |> addr |> to_voidp) ShaderUniformDataType.Vec3

(* Returns the shader and a function to be called whenever the view_pos changes *)
let load_ambient vertex_shader fragment_shader ambient_light =
  let shader = load_shader vertex_shader fragment_shader in
  Printf.printf "Shader ID is: %i\n" (Shader.id shader);
  if Shader.id shader = 0
  then failwith "Shader failed to compile";

  let mvp = get_shader_location shader "mvp" in
  let view_pos = get_shader_location shader "viewPos" in
  let instance = get_shader_location_attrib shader "instance" in
  let ambient = get_shader_location shader "ambient" in

  (* Get the locs array and assign the locations of the variables. This is necessary for the draw_mesh_instanced call.
   * Curiously, draw_mesh works without setting these. *)
  let locs = Shader.locs shader in
  CArray.set locs ShaderLocationIndex.(Matrix_mvp |> to_int) mvp;
  CArray.set locs ShaderLocationIndex.(Vector_view |> to_int) view_pos;
  CArray.set locs ShaderLocationIndex.(Matrix_model |> to_int) instance;
  set_shader_value shader ambient (ambient_light |> addr |> to_voidp) ShaderUniformDataType.Vec4;

  (shader, set_view_pos shader view_pos)
