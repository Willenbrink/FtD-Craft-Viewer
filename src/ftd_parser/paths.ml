open Util

let ftd_res = "~/.local/share/Steam/steamapps/common/From\\ The\\ Depths/From_The_Depths_Data/StreamingAssets/"
let personal_cons = "~/From\\ The\\ Depths/Player\\ Profiles/Ropianos/"

let find regex path =
  let ic = Unix.open_process_in ("fd " ^ regex ^ " " ^ path) in
  let res = ref [] in
  (try
    while true
    do
      res := input_line ic :: !res
    done
   with End_of_file -> ());
  !res

let get_files regex path =
  find regex path
  |> List.map (fun path -> list_of_path path |> List.rev |> List.hd, path)
  |> List.sort (fun (x,_) (y,_) -> String.compare x y)

let constructs_ftd =
  lazy (get_files ".*\\\\.blueprint$" ftd_res)

let constructs_personal =
  lazy (get_files ".*\\\\.blueprint$" personal_cons)

let items =
  lazy (get_files ".*\\\\.item$" ftd_res)

let meshes =
  lazy (get_files ".*\\\\.mesh$" ftd_res)

let objs =
  lazy (get_files ".*\\\\.obj$" ftd_res)
