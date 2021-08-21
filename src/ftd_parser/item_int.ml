open Util

type t = {
  active_block_link : Yo.t option [@key "ActiveBlockLink"] [@yojson.option];
  sounds : Item_ftd.sounds [@key "Sounds"];
  sub_objects : Item_ftd.sub_objects [@key "SubObjects"];
  mesh_reference : Common.reference [@key "MeshReference"];
  material_reference : Common.reference [@key "MaterialReference"];
  mirror_laterial_flip_replacement_reference : Common.reference [@key "MirrorLaterialFlipReplacementReference"];
  mirror_vertical_flip_replacement_reference : Common.reference [@key "MirrorVerticalFlipReplacementReference"];
  size_info : Item_ftd.size_info [@key "SizeInfo"];
  attach_directions : Item_ftd.directions [@key "AttachDirections"];
  support_directions : Item_ftd.directions [@key "SupportDirections"];
  allow_attaching_directions : Yo.t option [@key "AllowAttachingDirections"];
  weight : float [@key "Weight"];
  health : float [@key "Health"];
  armour_class : float [@key "ArmourClass"];
  e_radar_cross_section : float [@key "eRadarCrossSection"];
  radar_relative_cross_section : float [@key "RadarRelativeCrossSection"];
  extra_settings : Item_ftd.extra_settings [@key "ExtraSettings"];
  drag_settings : Item_ftd.drag_settings [@key "DragSettings"];
  code : Item_ftd.code [@key "Code"];
  item_type : int [@key "ItemType"];
  low_level_of_detail_color : v4 [@key "LowLevelOfDetailColor"];
  display_name : string [@key "DisplayName"];
  inventory_name_override : string [@key "InventoryNameOverride"];
  inventory_category_name_override : string [@key "InventoryCategoryNameOverride"];
  display_on_inventory : bool [@key "DisplayOnInventory"];
  inventory_x_position : int [@key "InventoryXPosition"];
  inventory_y_position : int [@key "InventoryYPosition"];
  inventory_tab_or_variant_id : Common.reference [@key "InventoryTabOrVariantId"];
  icon_reference : Common.reference [@key "IconReference"];
  complexity : int [@key "Complexity"];
  unlock : Yo.t option [@key "Unlock"];
  help_page_identifier_reference : Common.reference [@key "HelpPageIdentifierReference"];
  external_link : Item_ftd.external_link [@key "ExternalLink"];
  cost : float;
  component_id : Common.id [@key "ComponentId"];
  description : string [@key "Description"];
  release_in_feature : Yo.t option [@key "ReleaseInFeature"] [@yojson.option];
} [@@deriving show]

let item_int_of_ftd ({
  active_block_link; sounds; sub_objects;
  mesh_reference; material_reference;
  mirror_laterial_flip_replacement_reference;
  mirror_vertical_flip_replacement_reference;
  size_info; attach_directions; support_directions;
  allow_attaching_directions; weight; health;
  armour_class; e_radar_cross_section; radar_relative_cross_section;
  extra_settings; drag_settings; code; item_type;
  low_level_of_detail_color; display_name;
  inventory_name_override; inventory_category_name_override;
  display_on_inventory; inventory_x_position; inventory_y_position;
  inventory_tab_or_variant_id; icon_reference; complexity;
  unlock; help_page_identifier_reference; external_link;
  cost; component_id; description; release_in_feature;
} : Item_ftd.t) : t = {
  active_block_link; sounds; sub_objects; mesh_reference;
  material_reference; mirror_laterial_flip_replacement_reference;
  mirror_vertical_flip_replacement_reference;
  size_info; attach_directions; support_directions; allow_attaching_directions;
  weight; health; armour_class; e_radar_cross_section; radar_relative_cross_section;
  extra_settings; drag_settings; code; item_type; low_level_of_detail_color;
  display_name; inventory_name_override; inventory_category_name_override;
  display_on_inventory; inventory_x_position; inventory_y_position;
  inventory_tab_or_variant_id; icon_reference; complexity; unlock;
  help_page_identifier_reference; external_link; cost = cost.material; component_id;
  description; release_in_feature;
}

let parse t =
  Item_ftd.t_of_yojson t
  |> item_int_of_ftd
