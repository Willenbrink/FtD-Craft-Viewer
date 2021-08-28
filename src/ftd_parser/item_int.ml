open Util

type t = {
  (* active_block_link : Yo.t option; *)
  (* sounds : Item_ftd.sounds;
   * sub_objects : Item_ftd.sub_objects; *)
  mesh : Mesh_int.t;
  (* material_reference : Common.reference; *)
  (* mirror_laterial_flip_replacement_reference : Common.reference;
   * mirror_vertical_flip_replacement_reference : Common.reference; *)
  (* size_info : Item_ftd.size_info; *)
  (* attach_directions : Item_ftd.directions; *)
  (* support_directions : Item_ftd.directions; *)
  (* allow_attaching_directions : Yo.t option; *)
  (* weight : float; *)
  (* health : float; *)
  (* armour_class : float; *)
  (* e_radar_cross_section : float; *)
  (* radar_relative_cross_section : float; *)
  (* extra_settings : Item_ftd.extra_settings; *)
  (* drag_settings : Item_ftd.drag_settings; *)
  (* code : Item_ftd.code; *)
  (* item_type : int; *)
  (* low_level_of_detail_color : v4; *)
  (* display_name : string; *)
  (* inventory_name_override : string; *)
  (* inventory_category_name_override : string; *)
  (* display_on_inventory : bool; *)
  (* inventory_x_position : int; *)
  (* inventory_y_position : int; *)
  (* inventory_tab_or_variant_id : Common.reference; *)
  (* icon_reference : Common.reference; *)
  (* complexity : int; *)
  (* unlock : Yo.t option; *)
  (* help_page_identifier_reference : Common.reference; *)
  (* external_link : Item_ftd.external_link; *)
  cost : float;
  component_id : Common.id;
  (* description : string; *)
  (* release_in_feature : Yo.t option; *)
} [@@deriving show]

let item_int_of_ftd mesh_res ({
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
  mesh = mesh_res mesh_reference.reference.guid;
  cost = cost.material;
  component_id;
}

let item_int_of_dup_ftd item_res mesh_res ({
  size_info;
  drag_settings;
  display_name;
  inventory_name_override;
  inventory_category_name_override;
  id_to_duplicate;
  mesh_reference;
  material_reference;
  cost_weight_health_scaling;
  cost_scaling;
  health_scaling;
  armour_scaling;
  weight_scaling;
  volume_scaling;
  change_size_info;
  change_drag_settings;
  inventory_x_position;
  inventory_y_position;
  inventory_tab_or_variant_id;

  mirror_laterial_flip_replacement_reference;
  mirror_vertical_flip_replacement_reference;
  component_id;
  description;
} : Item_dup_ftd.t) : t =
  let item = item_res id_to_duplicate.reference.guid in
  {
  mesh = mesh_res mesh_reference.reference.guid;
  cost = item.cost;
  component_id;
}

let parse meshes t =
  Item_ftd.t_of_yojson t
  |> item_int_of_ftd meshes

let parse_dups items meshes t =
  Item_dup_ftd.t_of_yojson t
  |> item_int_of_dup_ftd items meshes
