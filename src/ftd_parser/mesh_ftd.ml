open Util

type t = {
  filename_or_url : string [@key "FilenameOrUrl"];
  source : int [@key "Source"];
  default_material_for_display_reference : Common.reference [@key "DefaultMaterialForDisplayReference"];
  x_import_scale_factor : float [@key "XImportScaleFactor"];
  y_import_scale_factor : float [@key "YImportScaleFactor"];
  z_import_scale_factor : float [@key "ZImportScaleFactor"];
  x_offset : float option [@key "XOffset"] [@yojson.option];
  z_offset : float option [@key "ZOffset"] [@yojson.option];
  component_id : Common.id [@key "ComponentId"];
  description : string [@key "Description"];
} [@@deriving show, yojson]
