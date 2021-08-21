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

let rec bp_int_of_ftd dict ({
  name; blueprint_name; blueprint_version; material_contained;
  csi; col; scs; blp; blr; bp1; bp2; bci; bei;
  block_data; vehicle_data; design_changed; serialised_info;
  item_number; local_position; local_rotation; force_id;
  total_block_count; max_cords; min_cords; block_ids;
  block_state; alive_count; block_string_data; block_string_data_ids;
  game_version; persistent_sub_object_index; persistent_block_index;
  author_details; block_count;
} : Construct_ftd.bp) : bp = {
  name; blueprint_name; blueprint_version; material_contained;
  item_number = (item_number, List.assoc item_number dict);
  csi; col;
  scs = List.map (bp_int_of_ftd dict) scs;
  blocks = Array.init block_count List.(fun i -> let id = nth block_ids i in ({
        id;
        typ = List.assoc id dict;
        pos = nth blp i;
        rot = Rotation.of_int (nth blr i);
        color = nth bci i;
      } : Block.t));
  bp1; bp2; bei; block_data; vehicle_data;
  design_changed; serialised_info;
  local_position;
  local_rotation; force_id; total_block_count; max_cords; min_cords;
  block_state; alive_count; block_string_data;
  block_string_data_ids; game_version; persistent_sub_object_index;
  persistent_block_index; author_details;
}

let rec bp_ftd_of_int ({
  name; blueprint_name; blueprint_version; material_contained;
  csi; col; scs; blocks; bp1; bp2; bei; block_data;
  vehicle_data; design_changed; serialised_info; item_number;
  local_position; local_rotation; force_id; total_block_count;
  max_cords; min_cords; block_state; alive_count;
  block_string_data; block_string_data_ids; game_version;
  persistent_sub_object_index; persistent_block_index; author_details;
} : bp) : Construct_ftd.bp =
  {
    material_contained; csi; col;
    scs = List.map bp_ftd_of_int scs;
    blp = List.init (Array.length blocks) (fun i -> blocks.(i).pos);
    blr = List.init (Array.length blocks) (fun i -> Rotation.int_of blocks.(i).rot);
    bci = List.init (Array.length blocks) (fun i -> blocks.(i).color);
    block_ids = List.init (Array.length blocks) (fun i -> blocks.(i).id);
    block_count = Array.length blocks;
    bp1; bp2;
    bei; block_data; vehicle_data; design_changed;
    blueprint_version; blueprint_name; serialised_info;
    name;
    item_number = fst item_number;
    local_position; local_rotation;
    force_id; total_block_count; max_cords; min_cords;
    block_state; alive_count; block_string_data;
    block_string_data_ids; game_version; persistent_sub_object_index;
    persistent_block_index; author_details;
}

let cons_int_of_ftd ({name; version; file_model_version;
                            saved_total_block_count; saved_material_cost;
                            contained_material_cost; item_dictionary; blueprint;
                           } : Construct_ftd.t) : t =
  {
  name;
  version;
  file_model_version;
  saved_total_block_count;
  saved_material_cost;
  contained_material_cost;
  blueprint = bp_int_of_ftd item_dictionary blueprint;
  }

let cons_ftd_of_int
    ({name; version; file_model_version;
      saved_total_block_count; saved_material_cost;
      contained_material_cost; blueprint;} : t)
  : Construct_ftd.t = {
  name;
  version;
  file_model_version;
  saved_total_block_count;
  saved_material_cost;
  contained_material_cost;
  item_dictionary = (
    let rec items (bp : bp) =
      bp.item_number
      :: (Array.to_list bp.blocks |> List.map (fun (b : Block.t) -> b.id,b.typ))
      @ List.concat_map items bp.scs
    in
    List.fold_left (fun acc b -> if List.mem_assoc (fst b) acc then acc else b :: acc) [] (items blueprint)
  );
  blueprint = bp_ftd_of_int blueprint;
  }

let blocks t =
  let rec blocks_bp bp = bp.blocks :: List.concat_map blocks_bp bp.scs in
  blocks_bp t.blueprint

let parse t =
  let version =
    try
      Yo.Util.(
        t
        |> member "Blueprint"
        |> member "GameVersion"
        |> to_string
        |> (fun str -> str,
                       try match str |> String.split_on_char '.' |> List.map int_of_string with
                           (3::_) -> true
                         | (2::minor::_) -> minor >= 7
                         | (1::_) -> false
                         | _ -> false
                       with _ -> false)
        |> (fun (str,supported) -> if not supported then raise (Unsupported_Version str) else str)
      )
    with Yo.Util.Type_error ("Expected string, got null", _) -> raise (Unsupported_Version "Error getting version")
  in
  (if !Cli.verbose >= 3 then Printf.printf "Blueprint version: %s\n" version);
  Construct_ftd.t_of_yojson t
  |> cons_int_of_ftd
