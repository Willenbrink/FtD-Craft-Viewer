open Util

type csi = float array [@@deriving show]

(* Possible related to subobjects? Only 4 models parse without option. *)
type col = v4 array option [@@deriving show]

type blp = v3i array [@@deriving show]

type blr = int array [@@deriving show]

type bp = {
  item_number : (int * Common.guid);
  name : string option;
  blueprint_name : string option;
  blueprint_version : int;
  blocks : Block.t array;
  scs : bp list;
  material_contained : float;
  csi : csi;
  col : col;
  bp1 : Yo.t;
  bp2 : Yo.t;
  bei : Yo.t;
  block_data : Yo.t;
  vehicle_data : Yo.t;
  design_changed : bool;
  serialised_info : Yo.t;
  local_position : v3;
  local_rotation : v4;
  force_id : int;
  total_block_count : int;
  max_cords : v3i;
  min_cords : v3i;
  block_state : Yo.t;
  alive_count : int;
  block_string_data : Yo.t;
  block_string_data_ids : Yo.t;
  game_version : string;
  persistent_sub_object_index : int;
  persistent_block_index : int;
  author_details : Common.author_details;
} [@@deriving show]

type t = {
  name : string option;
  file_model_version : Common.version;
  version : int;
  saved_total_block_count : int;
  saved_material_cost : float;
  contained_material_cost : float;
  blueprint : bp;
} [@@deriving show]

let blocks t =
  let rec blocks_bp bp = bp.blocks :: List.concat_map blocks_bp bp.scs in
  blocks_bp t.blueprint
