open Util

let ftd_res = "~/.local/share/Steam/steamapps/common/From\\ The\\ Depths/From_The_Depths_Data/StreamingAssets/"
let personal_cons = "~/From\\ The\\ Depths/Player\\ Profiles/Ropianos/"

let exclusions = [
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Meshes/ACB Controller panel_cdec460.mesh";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SimpleWeapon/Meshes/Autocannon Gatling_0ddc512.mesh";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Meshes/Boiler 5m Connector_1d5d774.mesh";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Meshes/Boiler 5m Control_21143ff.mesh";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Meshes/Boiler 5m End_f55d8e9.mesh";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Meshes/Boiler 5m_96d312d.mesh";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Meshes/Button Fast Forward_783f303.mesh";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/Panel.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SimpleWeapon/Assets/Autocannon Gatling.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Boiler5mConnector.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Boiler5mControl.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Boiler5mEnd.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Boiler5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/ButtonFFW.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/ButtonPause.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/ButtonPlay.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/ButtonRW.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/ButtonPlain.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/ButtonStop.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/ChaffEmitter.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_APS/Assets/Gauge cooler 5way.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_APS/Meshes/Gauge cooler 5way.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Laser/Assets/Laser Small Barrel.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Laser/Assets/Laser cavity.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Laser/Assets/Plasma_firingpiece.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Laser/Assets/Plasma_storage.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Laser/Assets/Plasma_tranciever.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/RadarDecoy.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderAttachment.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderCurveLargeDouble.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderCurveLargeSmall.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderCurveLarge.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_APS/Meshes/Gauge cooler 4way.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderCurveSmall.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderSquareSmall.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderSquare.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderTrapLargeHuge.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderTrapLargeSmall.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderTriangleLargeSmall.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderTriangleLarge.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderTriangleSmallHuge.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Surface/Assets/RudderTriangleSmall.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Resource/Assets/Scrap smelter base.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Resource/Assets/Scrap smelter top.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/shaft propeller 7m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Propeller 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Propeller 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Propeller 5mB.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear casing 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear casing 3m R.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear casing 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear casing 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear gear 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear gear 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear incoming shaft 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear incoming shaft 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear Incoming Shaft 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear outgoing shaft 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear outgoing shaft 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Reduction Gear outgoing shaft 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shaft Bearing 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shaft bearing 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shaft bearing 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis Frame 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis Frame 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis Frame 5m L.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis Frame 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis Gearbottom 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis Gearbottom 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis Gearbottom 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis GearMiddle 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis GearMiddle 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis GearMiddle 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis GearTop 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis GearTop 3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shift Axis GearTop 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Propeller 1m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/shaft wheel 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_AI/Assets/SignalJammer.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Misc/Assets/SonarDecoy.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Constructs/Assets/1mPistonBase.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Constructs/Assets/1mPistonOutter.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Constructs/Assets/1mPistonInner.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Constructs/Assets/2mPistonBase.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Constructs/Assets/2mPistonOutter.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_Constructs/Assets/2mPistonInner.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_ACDeco/Assets/Truss3m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/shaft crank 5m case.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/shaft crank 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Propshaft 5m.obj";
  "/home/sewi/.local/share/Steam/steamapps/common/From The Depths/From_The_Depths_Data/StreamingAssets/Mods/Core_SteamEngine/Assets/Shaft Shaft 5m.obj";
]

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
  |> List.filter (fun (_,x) -> List.mem x exclusions |> not)

let constructs_ftd =
  lazy (get_files ".*\\\\.blueprint$" ftd_res)

let constructs_personal =
  lazy (get_files ".*\\\\.blueprint$" personal_cons)

let items =
  lazy (get_files ".*\\\\.item$" ftd_res)

let item_dups =
  lazy (get_files ".*\\\\.itemduplicateandmodify$" ftd_res)

let meshes =
  lazy (get_files ".*\\\\.mesh$" ftd_res)

let objs =
  lazy (get_files ".*\\\\.obj$" ftd_res)
