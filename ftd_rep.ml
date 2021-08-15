open Util

type version = {
  major : int [@key "Major"];
  minor : int [@key "Minor"];
} [@@deriving show, yojson]
let version_of_yojson t = [%of_yojson: version] t |> check (fun v -> v.major = 1 && v.minor = 0)

type item_dictionary = (int * Common.guid) list [@@deriving show]
let item_dictionary_of_yojson t = Yo.Util.to_assoc t |> List.map (fun (id,x) -> (int_of_string id, string_of_yojson x))
let yojson_of_item_dictionary t = `Assoc (List.map (fun (id,x) -> (string_of_int id, `String x)) t)

(* GUIDs are IDs used everywhere and unique to everything. That means, authors and crafts share the same id type. *)
type author_details = {
  valid : bool [@key "Valid"];
  foreign_blocks : int [@key "ForeignBlocks"];
  creator_id : string [@key "CreatorId"];
  object_id : string [@key "ObjectId"];
  creator_readable_name : string [@key "CreatorReadableName"];
  hash_v1 : string [@key "HashV1"];
} [@@deriving show, yojson]

type csi = float array [@@deriving show]
let csi_of_yojson t = [%of_yojson: float list] t |> Array.of_list
let yojson_of_csi t = Array.to_list t |> [%yojson_of: float list]

(* Possible related to subobjects? Only 4 models parse without option. *)
type col = v4 array option [@@deriving show]
let invar_col t = Option.map (check (fun x -> Array.length x = 32)) t
let col_of_yojson t = [%of_yojson: v4 list option] t |> Option.map Array.of_list |> invar_col
let yojson_of_col t =
  invar_col t
  |> Option.map Array.to_list
  |> [%yojson_of: v4 list option]

type blp = v3i array [@@deriving show]
let blp_of_yojson t = [%of_yojson: v3i list] t |> Array.of_list
let yojson_of_blp t = Array.to_list t |> [%yojson_of: v3i list]

type blr = int array [@@deriving show]
let blr_of_yojson t = [%of_yojson: int list] t |> Array.of_list
let yojson_of_blr t = Array.to_list t |> [%yojson_of: int list]

type blueprint = {
  material_contained : float [@key "ContainedMaterialCost"];
  csi : csi [@key "CSI"] [@opaque];
  col : col [@key "COL"] [@opaque];
  scs : blueprint list [@key "SCs"];
  blp : blp [@key "BLP"];
  blr : blr [@key "BLR"];
  bp1 : Yo.t [@key "BP1"];
  bp2 : Yo.t [@key "BP2"];
  block_colors : int list [@key "BCI"] [@opaque];
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
  author_details : author_details [@key "AuthorDetails"] [@opaque];
  block_count : int [@key "BlockCount"];
  (* id : int [@key "Id"];
   * last_alive_block : int [@key "LastAliveBlock"];
   * index_of_first_block_needing_full_repair_cost : int [@key "IndexOfFirstBlockNeedingFullRepairCost"]; *)
} [@@deriving show, yojson]

type construct = {
  file_model_version : version [@key "FileModelVersion"];
  name : string option [@key "Name"];
  version : int [@key "Version"];
  saved_total_block_count : int [@key "SavedTotalBlockCount"];
  saved_material_cost : float [@key "SavedMaterialCost"];
  contained_material_cost : float [@key "ContainedMaterialCost"];
  item_dictionary : item_dictionary [@key "ItemDictionary"];
  blueprint : blueprint [@key "Blueprint"];
} [@@deriving show, yojson]

let parse_construct t =
  (try
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
      |> (fun (str,supported) -> if not supported then raise (Unsupported_Version str) else ())
    )
  with _ -> raise (Unsupported_Version "Error getting version"));
  construct_of_yojson t
