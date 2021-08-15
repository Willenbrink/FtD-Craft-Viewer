open Util

type rotation =
    Forward
  | Back
  | Right
  | Left
  | Up
  | Down
  | Unknown of int
[@@deriving show]
let rotation_of_int t = match t with
   x -> Unknown x
  | 0 -> Forward
  | 1 -> Right
  | 2 -> Back
  | 3 -> Left
  | 4 -> Down
  | 8 -> Up
    (* Rot R *)
  | 16 -> Forward
  | 22 -> Right
  | 19 -> Back
  | 21 -> Left
  | 5 -> Down
  | 9 -> Up
    (* Rot RR *)
  | 12 -> Forward
  | 13 -> Right
  | 14 -> Back
  | 15 -> Left
  | 6 -> Down
  | 10 -> Up
    (* Rot RRR *)
  | 18 -> Forward
  | 20 -> Right
  | 17 -> Back
  | 23 -> Left
  | 7 -> Down
  | 11 -> Up
  | x -> Printf.fprintf stderr "Unknown rotation: %i.\n" x; Unknown x

let int_of_rotation t = match t with
  Unknown x -> x

type item_dictionary = (int * Common.guid) list [@@deriving show]

type csi = float array [@@deriving show]

(* Possible related to subobjects? Only 4 models parse without option. *)
type col = v4 array option [@@deriving show]

type blp = v3i array [@@deriving show]

type blr = int array [@@deriving show]

type block = {id : int; pos : v3i; rot : rotation; color : int; } [@@deriving show]

type blueprint_int = {
  name : string option;
  blueprint_name : string option;
  blueprint_version : int;
  blocks : block array;
  scs : blueprint_int list;
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
  item_number : int;
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
  author_details : Ftd_rep.author_details;
} [@@deriving show]

type construct_int = {
  name : string option;
  file_model_version : Ftd_rep.version;
  version : int;
  saved_total_block_count : int;
  saved_material_cost : float;
  contained_material_cost : float;
  item_dictionary : item_dictionary;
  blueprint : blueprint_int;
} [@@deriving show]

let rec blueprint_int_of_blueprint ({
  name; blueprint_name; blueprint_version; material_contained;
  csi; col; scs; blp; blr; bp1; bp2; bci; bei;
  block_data; vehicle_data; design_changed; serialised_info;
  item_number; local_position; local_rotation; force_id;
  total_block_count; max_cords; min_cords; block_ids;
  block_state; alive_count; block_string_data; block_string_data_ids;
  game_version; persistent_sub_object_index; persistent_block_index;
  author_details; block_count;
} : Ftd_rep.blueprint) = {
  name; blueprint_name; blueprint_version; material_contained;
  csi; col;
  scs = List.map blueprint_int_of_blueprint scs;
  blocks = Array.init block_count List.(fun i -> {
        id = nth block_ids i;
        pos = nth blp i;
        rot = rotation_of_int (nth blr i);
        color = nth bci i;
      });
  bp1; bp2; bei; block_data; vehicle_data;
  design_changed; serialised_info; item_number; local_position;
  local_rotation; force_id; total_block_count; max_cords; min_cords;
  block_state; alive_count; block_string_data;
  block_string_data_ids; game_version; persistent_sub_object_index;
  persistent_block_index; author_details;
}

let rec blueprint_of_blueprint_int ({
  name; blueprint_name; blueprint_version; material_contained;
  csi; col; scs; blocks; bp1; bp2; bei; block_data;
  vehicle_data; design_changed; serialised_info; item_number;
  local_position; local_rotation; force_id; total_block_count;
  max_cords; min_cords; block_state; alive_count;
  block_string_data; block_string_data_ids; game_version;
  persistent_sub_object_index; persistent_block_index; author_details;
} : blueprint_int) : Ftd_rep.blueprint =
  {
    material_contained; csi; col;
    scs = List.map blueprint_of_blueprint_int scs;
    blp = List.init (Array.length blocks) (fun i -> blocks.(i).pos);
    blr = List.init (Array.length blocks) (fun i -> int_of_rotation (blocks.(i).rot));
    bci = List.init (Array.length blocks) (fun i -> blocks.(i).color);
    block_ids = List.init (Array.length blocks) (fun i -> blocks.(i).id);
    block_count = Array.length blocks;
    bp1; bp2;
    bei; block_data; vehicle_data; design_changed;
    blueprint_version; blueprint_name; serialised_info;
    name; item_number; local_position; local_rotation;
    force_id; total_block_count; max_cords; min_cords;
    block_state; alive_count; block_string_data;
    block_string_data_ids; game_version; persistent_sub_object_index;
    persistent_block_index; author_details;
}

let internal_of_construct ({name; version; file_model_version; saved_total_block_count; saved_material_cost; contained_material_cost; item_dictionary; blueprint;} : Ftd_rep.construct) = {
  name;
  version;
  file_model_version;
  saved_total_block_count;
  saved_material_cost;
  contained_material_cost;
  item_dictionary;
  blueprint = blueprint_int_of_blueprint blueprint;
  }

let construct_of_internal {name; version; file_model_version; saved_total_block_count; saved_material_cost; contained_material_cost; item_dictionary; blueprint;} : Ftd_rep.construct = {
  name;
  version;
  file_model_version;
  saved_total_block_count;
  saved_material_cost;
  contained_material_cost;
  item_dictionary;
  blueprint = blueprint_of_blueprint_int blueprint;
  }
