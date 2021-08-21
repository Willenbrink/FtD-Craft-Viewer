open Util

type item_dictionary = (int * Common.guid) list [@@deriving show]
let item_dictionary_of_yojson t = Yo.Util.to_assoc t |> List.map (fun (id,x) -> (int_of_string id, string_of_yojson x))
let yojson_of_item_dictionary t = `Assoc (List.map (fun (id,x) -> (string_of_int id, `String x)) t)

type csi = float array [@@deriving show]
(* Dependant on the version. From 3.0 onwards it is 80 *)
let invar_csi t = check "CSI" (fun x -> Array.length x = 65 || Array.length x = 70 || Array.length x = 80) t
let csi_of_yojson t = [%of_yojson: float list] t |> Array.of_list |> invar_csi
let yojson_of_csi t = Array.to_list t |> [%yojson_of: float list]

(* Possible related to subobjects? Only 4 models parse without option. *)
type col = v4 array option [@@deriving show]
let invar_col t = Option.map (check "COL" (fun x -> Array.length x = 32)) t
let col_of_yojson t = [%of_yojson: v4 list option] t |> Option.map Array.of_list |> invar_col
let yojson_of_col t =
  invar_col t
  |> Option.map Array.to_list
  |> [%yojson_of: v4 list option]

type bp = {
  material_contained : float [@key "ContainedMaterialCost"];
  csi : csi [@key "CSI"] [@opaque];
  col : col [@key "COL"] [@opaque];
  scs : bp list [@key "SCs"];
  blp : v3i list [@key "BLP"];
  blr : int list [@key "BLR"];
  bp1 : Yo.t [@key "BP1"];
  bp2 : Yo.t [@key "BP2"];
  bci : int list [@key "BCI"] [@opaque];
  bei : Yo.t [@key "BEI"];
  block_data : Yo.t [@key "BlockData"] [@opaque];
  vehicle_data : Yo.t [@key "VehicleData"] [@opaque];
  design_changed : bool [@key "designChanged"];
  blueprint_version : int [@key "blueprintVersion"];
  blueprint_name : string option [@key "blueprintName"];
  serialised_info : Yo.t [@key "SerialisedInfo"];
  name : string option [@key "Name"];
  item_number : int [@key "ItemNumber"];
  local_position : v3 [@key "LocalPosition"];
  local_rotation : v4 [@key "LocalRotation"];
  force_id : int [@key "ForceId"];
  total_block_count : int [@key "TotalBlockCount"];
  max_cords : v3i [@key "MaxCords"];
  min_cords : v3i [@key "MinCords"];
  block_ids : int list [@key "BlockIds"];
  block_state : Yo.t [@key "BlockState"];
  alive_count : int [@key "AliveCount"];
  block_string_data : Yo.t [@key "BlockStringData"];
  block_string_data_ids : Yo.t [@key "BlockStringDataIds"];
  game_version : string [@key "GameVersion"];
  persistent_sub_object_index : int [@key "PersistentSubObjectIndex"];
  persistent_block_index : int [@key "PersistentBlockIndex"];
  author_details : Common.author_details [@key "AuthorDetails"] [@opaque];
  block_count : int [@key "BlockCount"];
} [@@deriving show, yojson]
let blueprint_of_yojson t =
  let r = [%of_yojson: bp] t in
  r
  |> check "Block counts of blueprint" List.(fun r -> let bc = r.block_count in bc = length r.blp && bc = length r.blr && bc = length r.block_ids && bc = length r.bci)

type t = {
  file_model_version : Common.version [@key "FileModelVersion"];
  name : string option [@key "Name"];
  version : int [@key "Version"];
  saved_total_block_count : int [@key "SavedTotalBlockCount"];
  saved_material_cost : float [@key "SavedMaterialCost"];
  contained_material_cost : float [@key "ContainedMaterialCost"];
  item_dictionary : item_dictionary [@key "ItemDictionary"];
  blueprint : bp [@key "Blueprint"];
} [@@deriving show, yojson]
