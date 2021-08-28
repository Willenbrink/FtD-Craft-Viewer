open Util

type t = {
  mesh : Raylib.Mesh.t [@printer fun fmt obj -> fprintf fmt "<opaque>"];
  source : int;
  default_material_for_display_reference : Common.reference;
  x_import_scale_factor : float;
  y_import_scale_factor : float;
  z_import_scale_factor : float;
  z_offset : float option;
  component_id : Common.id;
  description : string;
} [@@deriving show]

let mesh_default = lazy(
  {
    mesh = Raylib.gen_mesh_cube 1.0 1.0 1.0;
    source = -1;
    default_material_for_display_reference = {reference = {guid = Common.Guid.t_of_string ""; name = "TODO"} ; is_valid_reference = false;};
    x_import_scale_factor = 0.0;
    y_import_scale_factor = 0.0;
    z_import_scale_factor = 0.0;
    z_offset = Some 0.0;
    component_id = {guid = Common.Guid.t_of_string "" ; name = "TODO"};
    description = "";
  })

let mesh_int_of_ftd ({
    filename_or_url; source; default_material_for_display_reference;
    x_import_scale_factor; y_import_scale_factor; z_import_scale_factor;
    z_offset; component_id; description;
  } : Mesh_ftd.t) : t =
  {
    mesh =
      (let name = List.assoc_opt filename_or_url (Lazy.force Paths.objs) in
       match name with
       | None -> raise (Invariant_violated ".obj of mesh cannot be parsed")
       | Some name -> Ctypes.CArray.get (Raylib.load_model name |> Raylib.Model.meshes) 0 );
    source; default_material_for_display_reference;
    x_import_scale_factor; y_import_scale_factor; z_import_scale_factor;
    z_offset; component_id; description;
  }

let parse t =
  Mesh_ftd.t_of_yojson t
|> mesh_int_of_ftd
