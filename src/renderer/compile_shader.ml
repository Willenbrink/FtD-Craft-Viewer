let int_big_arr len = Bigarray.(Array1.create int32 c_layout len)

let query f len =
  let arr = int_big_arr len in
  f arr;
  arr

let query_single f =
  let arr = int_big_arr 1 in
  f arr;
  Bigarray.(Array1.get arr 0)
  |> Int32.to_int

let str_of_arr arr len =
  let rec aux acc i =
    if i < 0
    then String.of_seq acc
    else aux (Seq.cons (Bigarray.Array1.get arr i) acc) (i-1)
  in
  aux Seq.empty (len - 1)

let load_shader_program vs_id fs_id =
  let open Tgl4.Gl in
  let program = create_program () in
  attach_shader program vs_id;
  attach_shader program fs_id;

  bind_attrib_location program 0 "vertexPosition";
  bind_attrib_location program 1 "vertexTexCoord";
  bind_attrib_location program 2 "vertexNormal";
  bind_attrib_location program 3 "vertexColor";
  bind_attrib_location program 4 "vertexTangent";
  bind_attrib_location program 5 "vertexTexCoord2";
  link_program program;

  if query_single (get_programiv program link_status) <> false_
  then Either.left program
  else
    let max_length = query_single (get_programiv program info_log_length) in
    (* if max_length > 0
     * then *)
    let log = Bigarray.(Array1.create char c_layout max_length) in
    let len = query_single (fun arr -> get_program_info_log program max_length arr log) in
    delete_program program;
    Either.right (str_of_arr log len)

let load_shader_code vs_code fs_code =
  let open Tgl4.Gl in
  let vs_id = rl_compile_shader vs_code vertex_shader in
  let fs_id = rl_compile_shader fs_code fragment_shader in
  let prog = load_shader_program vs_id fs_id in
  let id = match prog with
  | Right str -> failwith str
  | Left id ->
    detach_shader id vs_id;
    delete_shader vs_id;
    detach_shader id fs_id;
    delete_shader fs_id;
    assert (id <> 0);
    id
  in
  let uniform_count =
    query_single (fun arr -> Bigarray.Array1.set arr 0 Int32.zero; get_programiv id active_uniforms arr)
  in
  ignore uniform_count;
  id

(*
 *  DEBUG CODE for uniform_count
 *     for (int i = 0; i < uniformCount; i++)
 *     {
 *         int namelen = -1;
 *         int num = -1;
 *         char name[256] = { 0 };     // Assume no variable names longer than 256
 *         GLenum type = GL_ZERO;
 *
 *         // Get the name of the uniforms
 *         glGetActiveUniform(id, i, sizeof(name) - 1, &namelen, &num, &type, name);
 *
 *         name[namelen] = 0;
 *
 *         TRACELOGD("SHADER: [ID %i] Active uniform (%s) set at location: %i", id, name, glGetUniformLocation(id, name));
 *     }
 *)

let load_shader vs_code fs_code =
  let open Raylib in
  let locs = Array.init 32 (fun _ -> Int64.of_int (-1)) |> Bigarray.(Array1.of_array int64 c_layout) in
  let id = load_shader_code vs_code fs_code in

  let attributes = ShaderLocationIndex.[
    (Vertex_position, "vertexPosition");
    (Vertex_texcoord01, "vertexTexCoord");
    (Vertex_texcoord02, "vertexTexCoord2");
    (Vertex_normal, "vertexNormal");
    (Vertex_tangent, "vertexTangent");
    (Vertex_color, "vertexColor");
  ]
  in
  List.iter (fun (pos, name) ->
      Bigarray.Array1.set locs
        (ShaderLocationIndex.to_int pos)
        (rlGetLocationAttrib id name)
    ) attributes;

  let uniforms = ShaderLocationIndex.[
    (Matrix_mvp, "mvp");
    (Matrix_view, "matView");
    (Matrix_projection, "matProjection");
    (Matrix_model, "matModel");
    (Matrix_normal, "matNormal");
    (Color_diffuse, "colDiffuse");
    (Map_albedo, "texture0");
    (Map_metalness, "texture1");
    (Map_normal, "texture2")
  ]
  in
  List.iter (fun (pos, name) ->
      Bigarray.Array1.set locs
        (ShaderLocationIndex.to_int pos)
        (rlGetLocationUniform id name)
    ) attributes;
  let shader = Ctypes.make Shader.t in
  Ctypes.setf shader Shader.id id;
  Ctypes.setf shader Shader.locs locs;
  shader
