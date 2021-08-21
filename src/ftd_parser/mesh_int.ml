open Util

type t = {
  obj : Raylib.Model.t;
  source : int;
  default_material_for_display_reference : Common.reference;
  x_import_scale_factor : float;
  y_import_scale_factor : float;
  z_import_scale_factor : float;
  z_offset : float option;
  component_id : Common.id;
  description : string;
}

let mesh_int_of_ftd ({
    filename_or_url; source; default_material_for_display_reference;
    x_import_scale_factor; y_import_scale_factor; z_import_scale_factor;
    z_offset; component_id; description;
  } : Mesh_ftd.t) : t =
  {
    obj = Raylib.load_model (List.assoc filename_or_url (Lazy.force Paths.objs));
    source; default_material_for_display_reference;
    x_import_scale_factor; y_import_scale_factor; z_import_scale_factor;
    z_offset; component_id; description;
  }

let parse t =
  Mesh_ftd.t_of_yojson t
|> mesh_int_of_ftd
