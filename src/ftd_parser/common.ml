open Util

(* GUIDs are IDs used everywhere and unique to everything. That means, authors and crafts share the same id type. *)
type guid = string [@@deriving show, yojson_of]
let invar_guid str = Str.string_match (Str.regexp "........-....-....-....-............$") str 0
let guid_of_yojson t = [%of_yojson: string] t |> check "GUID" invar_guid

type id = {
  guid : guid [@key "Guid"];
  name : string [@key "Name"];
} [@@deriving show, yojson]

type reference = {
  reference : id [@key "Reference"];
  is_valid_reference : bool [@key "IsValidReference"];
} [@@deriving show, yojson]

type author_details = {
  valid : bool [@key "Valid"];
  foreign_blocks : int [@key "ForeignBlocks"];
  creator_id : guid [@key "CreatorId"];
  object_id : guid [@key "ObjectId"];
  creator_readable_name : string [@key "CreatorReadableName"];
  hash_v1 : string [@key "HashV1"];
} [@@deriving show, yojson]

type version = {
  major : int [@key "Major"];
  minor : int [@key "Minor"];
} [@@deriving show, yojson]
let version_of_yojson t = [%of_yojson: version] t |> check "Version" (fun v -> v.major = 1 && v.minor = 0)
