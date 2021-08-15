open Util

type guid = string [@@deriving show, yojson_of]
let invar_guid str = Str.string_match (Str.regexp "........-....-....-....-............$") str 0
let guid_of_yojson t = [%of_yojson: string] t |> check invar_guid

type id = {
  guid : guid [@key "Guid"];
  name : string [@key "Name"];
} [@@deriving show, yojson]

type reference = {
  reference : id [@key "Reference"];
  is_valid_reference : bool [@key "IsValidReference"];
} [@@deriving show, yojson]
