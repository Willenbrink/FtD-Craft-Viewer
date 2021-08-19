open Util

let rec bp_int_of_ftd dict ({
  name; blueprint_name; blueprint_version; material_contained;
  csi; col; scs; blp; blr; bp1; bp2; bci; bei;
  block_data; vehicle_data; design_changed; serialised_info;
  item_number; local_position; local_rotation; force_id;
  total_block_count; max_cords; min_cords; block_ids;
  block_state; alive_count; block_string_data; block_string_data_ids;
  game_version; persistent_sub_object_index; persistent_block_index;
  author_details; block_count;
} : Construct_ftd.bp) : Construct_internal.bp = {
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
} : Construct_internal.bp) : Construct_ftd.bp =
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
                           } : Construct_ftd.t) : Construct_internal.t =
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
      contained_material_cost; blueprint;} : Construct_internal.t)
  : Construct_ftd.t = {
  name;
  version;
  file_model_version;
  saved_total_block_count;
  saved_material_cost;
  contained_material_cost;
  item_dictionary = (
    let rec items (bp : Construct_internal.bp) =
      bp.item_number
      :: (Array.to_list bp.blocks |> List.map (fun (b : Block.t) -> b.id,b.typ))
      @ List.concat_map items bp.scs
    in
    List.fold_left (fun acc b -> if List.mem_assoc (fst b) acc then acc else b :: acc) [] (items blueprint)
  );
  blueprint = bp_ftd_of_int blueprint;
  }
