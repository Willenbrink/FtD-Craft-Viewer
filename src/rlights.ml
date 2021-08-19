open Raylib

let lights_count = ref 0
let max_lights = 4

type light_type = Directional | Point

let int_of_light_type = function
  | Directional -> 0
  | Point -> 1

type light = {
  typ : light_type;
  position : Vector3.t;
  target : Vector3.t;
  color : Color.t;
  enabled : bool;

  loc_enabled : ShaderLoc.t;
  loc_typ : ShaderLoc.t;
  loc_pos : ShaderLoc.t;
  loc_target : ShaderLoc.t;
  loc_color : ShaderLoc.t;
}

let update_light_values shader light =
  let enabled = Ctypes.allocate Ctypes.bool light.enabled in
  set_shader_value shader light.loc_enabled (to_voidp enabled) ShaderUniformDataType.Int;
  let typ = Ctypes.allocate Ctypes.int (int_of_light_type light.typ) in
  set_shader_value shader light.loc_typ (to_voidp typ) ShaderUniformDataType.Int;

  set_shader_value shader light.loc_pos (to_voidp (addr light.position)) ShaderUniformDataType.Vec3;
  set_shader_value shader light.loc_target (to_voidp (addr light.target)) ShaderUniformDataType.Vec3;
  let color = Vector4.(create
                         ((Ctypes.getf light.color Color.r |> Unsigned.UChar.to_int |> float) /. 255.0)
                         ((Ctypes.getf light.color Color.g |> Unsigned.UChar.to_int |> float) /. 255.0)
                         ((Ctypes.getf light.color Color.b |> Unsigned.UChar.to_int |> float) /. 255.0)
                         ((Ctypes.getf light.color Color.a |> Unsigned.UChar.to_int |> float) /. 255.0)
                      )
  in
  set_shader_value shader light.loc_color (to_voidp (addr color)) ShaderUniformDataType.Vec4

let create_light typ position target color shader =
  if !lights_count > max_lights
  then failwith "Too many lights"
  else
    let enabled_name = Printf.sprintf "lights[%i].enabled" (!lights_count) in
    let typ_name = Printf.sprintf "lights[%i].type" (!lights_count) in
    let pos_name = Printf.sprintf "lights[%i].position" (!lights_count) in
    let target_name = Printf.sprintf "lights[%i].target" (!lights_count) in
    let color_name = Printf.sprintf "lights[%i].color" (!lights_count) in
    let light = {enabled = true; typ; position; target; color;
                 loc_enabled = get_shader_location shader enabled_name;
                 loc_typ = get_shader_location shader typ_name;
                loc_pos = get_shader_location shader pos_name;
                loc_target = get_shader_location shader target_name;
                loc_color = get_shader_location shader color_name;
              }
    in
    update_light_values shader light;
    lights_count := !lights_count + 1;
    light
