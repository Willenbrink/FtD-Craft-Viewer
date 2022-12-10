open Util

type sound = {
  sound_reference : Common.reference [@key "SoundReference"];
  volume : float [@key "Volume"];
  min_distance : float [@key "MinDistance"];
  pitch : float [@key "Pitch"];
  doppler : float [@key "Doppler"];
  priority : int [@key "Priority"];} [@@deriving show, yojson]

type sounds = {
  view_these_options : bool [@key "ViewTheseOptions"];
  sounds : sound list [@key "Sounds"];
  sound_count : int [@key "SoundCount"];
} [@@deriving show, yojson]

type sub_object = {
  paint_with_block : Yo.t [@key "PaintWithBlock"];
  decorative_only : Yo.t [@key "DecorativeOnly"];
  object_reference : Yo.t [@key "ObjectReference"];
  local_position : Yo.t [@key "LocalPosition"];
  local_rotation : Yo.t [@key "LocalRotation"];
} [@@deriving show, yojson]

type sub_objects = {
  view_these_options : bool [@key "ViewTheseOptions"];
  sub_object_count : int [@key "SubObjectCount"];
  sub_objects : sub_object list [@key "SubObjects"];
} [@@deriving show, yojson]

type size_info = {
  view_these_option : bool [@key "ViewTheseOptions"];
  size_pos : Yo.t [@key "SizePos"];
  size_neg : Yo.t [@key "SizeNeg"];
  volume_factor : Yo.t [@key "VolumeFactor"];
  volume_buoyancy_extra_factor : Yo.t [@key "VolumeBuoyancyExtraFactor"];
  array_positions_used : Yo.t [@key "ArrayPositionsUsed"];
  local_center : Yo.t [@key "LocalCenter"];
} [@@deriving show, yojson]

type directions = {
  up : Yo.t [@key "Up"];
  down : Yo.t [@key "Down"];
  right : Yo.t [@key "Right"];
  left : Yo.t [@key "Left"];
  forwards : Yo.t [@key "Forwards"];
  back : Yo.t [@key "Back"];
} [@@deriving show, yojson]

type extra_settings = {
  create_list_of_these_blocks : Yo.t [@key "CreateListOfTheseBlocks"];
  use_custom_name : Yo.t [@key "UseCustomName"];
  explosion_on_death : Yo.t [@key "ExplosionOnDeath"];
  view_these_options : bool [@key "ViewTheseOptions"];
  use_a_low_lod_render : Yo.t [@key "UseALowLodRender"];
  water_tight : Yo.t [@key "WaterTight"];
  block_pathfinding : Yo.t [@key "BlockPathfinding"];
  view_mesh_when_placing : bool [@key "ViewMeshWhenPlacing"];
  local_rotation_to_forward : bool [@key "LocalRotationToForward"];
  inventory_link_up : bool [@key "InventoryLinkUp"];
  inventory_link_down : bool [@key "InventoryLinkDown"];
  inventory_link_left : bool [@key "InventoryLinkLeft"];
  inventory_link_right : bool [@key "InventoryLinkRight"];
  placeable_on_fortress : bool [@key "PlaceableOnFortress"];
  placeable_on_structure : bool [@key "PlaceableOnStructure"];
  placeable_on_vehicle : bool [@key "PlaceableOnVehicle"];
  placeable_in_prefab : bool [@key "PlaceableInPrefab"];
  placeable_on_sub_constructable : int [@key "PlaceableOnSubConstructable"];
  automatically_generate_collider : Yo.t [@key "AutomaticallyGenerateCollider"];
  structural_component : Yo.t [@key "StructuralComponent"];
  emp_susceptibility : Yo.t [@key "EmpSusceptibility"];
  emp_resistivity : Yo.t [@key "EmpResistivity"];
  emp_damage_factor : Yo.t [@key "EmpDamageFactor"];
  fraction_heat_damage_per_meter_penetration : Yo.t [@key "FractionHeatDamagePerMeterPenetration"];
  allows_exhaust : Yo.t [@key "AllowsExhaust"];
  allows_visible_band_transmission : Yo.t [@key "AllowsVisibleBandTransmission"];
  allows_ir_band_transmission : Yo.t [@key "AllowsIrBandTransmission"];
  allows_radar_band_transmission : Yo.t [@key "AllowsRadarBandTransmission"];
  allows_sonar_band_transmission : Yo.t [@key "AllowsSonarBandTransmission"];
  render_in_important_view : Yo.t [@key "RenderInImportantView"];
} [@@deriving show, yojson]

type drag_settings = {
  drag_clearance_positions : Yo.t [@key "DragClearancePositions"];
  drag_factor_neg : Yo.t [@key "DragFactorNeg"];
  drag_factor_pos : Yo.t [@key "DragFactorPos"];
  drag_stopper : Yo.t [@key "DragStopper"];
  view_these_options : bool [@key "ViewTheseOptions"];
  geometry : Yo.t [@key "Geometry"];
} [@@deriving show, yojson]

type code = {
  group_connection_info : Yo.t [@key "GroupConnectionInfo"];
  view_these_options : bool [@key "ViewTheseOptions"];
  variables : Yo.t [@key "Variables"];
  class_name : Yo.t [@key "ClassName"];
} [@@deriving show, yojson]

type external_link = {
  name : Yo.t [@key "Name"];
  url : Yo.t [@key "Url"];
} [@@deriving show, yojson]

type cost = {
  material : float [@key "Material"];
} [@@deriving show, yojson]

type t = {
  active_block_link : Yo.t option [@key "ActiveBlockLink"] [@yojson.option];
  sounds : sounds [@key "Sounds"];
  sub_objects : sub_objects [@key "SubObjects"];
  mesh_reference : Common.reference [@key "MeshReference"];
  material_reference : Common.reference [@key "MaterialReference"];
  mirror_laterial_flip_replacement_reference : Common.reference [@key "MirrorLaterialFlipReplacementReference"];
  mirror_vertical_flip_replacement_reference : Common.reference [@key "MirrorVerticalFlipReplacementReference"];
  size_info : size_info [@key "SizeInfo"];
  attach_directions : directions [@key "AttachDirections"];
  support_directions : directions [@key "SupportDirections"];
  allow_attaching_directions : Yo.t option [@key "AllowAttachingDirections"];
  weight : float [@key "Weight"];
  health : float [@key "Health"];
  armour_class : float [@key "ArmourClass"];
  e_radar_cross_section : float [@key "eRadarCrossSection"];
  radar_relative_cross_section : float [@key "RadarRelativeCrossSection"];
  extra_settings : extra_settings [@key "ExtraSettings"];
  drag_settings : drag_settings [@key "DragSettings"];
  code : code [@key "Code"];
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
  unlock : Yo.t option [@key "Unlock"] [@yojson.option];
  help_page_identifier_reference : Common.reference [@key "HelpPageIdentifierReference"];
  external_link : external_link [@key "ExternalLink"];
  cost : cost [@key "Cost"];
  component_id : Common.id [@key "ComponentId"];
  description : string [@key "Description"];
  release_in_feature : Yo.t option [@key "ReleaseInFeature"] [@yojson.option];
} [@@deriving show, yojson]

let parse _ = t_of_yojson
