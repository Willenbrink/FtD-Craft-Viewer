open Util
open Item_ftd

type t = {
  size_info : size_info option [@key "SizeInfo"];
  drag_settings : drag_settings option [@key "DragSettings"];
  display_name : string option [@key "DisplayName"] [@yojson.option];
  inventory_name_override : string [@key "InventoryNameOverride"];
  inventory_category_name_override : string option [@key "CategoryNameOverride"] [@yojson.option];
  id_to_duplicate : Common.reference [@key "IdToDuplicate"];
  mesh_reference : Common.reference [@key "MeshReference"];
  material_reference : Common.reference [@key "MaterialReference"];
  cost_weight_health_scaling : Yo.t [@key "CostWeightHealthScaling"];
  cost_scaling : Yo.t [@key "CostScaling"];
  health_scaling : Yo.t [@key "HealthScaling"];
  armour_scaling : Yo.t [@key "ArmourScaling"];
  weight_scaling : Yo.t [@key "WeightScaling"];
  volume_scaling : Yo.t [@key "VolumeScaling"];
  change_size_info : Yo.t [@key "change_SizeInfo"];
  change_drag_settings : Yo.t [@key "change_DragSettings"];
  inventory_x_position : int [@key "InventoryXPosition"];
  inventory_y_position : int [@key "InventoryYPosition"];
  inventory_tab_or_variant_id : Common.reference [@key "InventoryTabOrVariantId"];
  display_on_inventory : bool [@key "DisplayOnInventory"];
  mirror_laterial_flip_replacement_reference : Common.reference [@key "MirrorLaterialFlipReplacementReference"];
  mirror_vertical_flip_replacement_reference : Common.reference [@key "MirrorVerticalFlipReplacementReference"];
  component_id : Common.id [@key "ComponentId"];
  description : string [@key "Description"];
} [@@deriving show, yojson]
