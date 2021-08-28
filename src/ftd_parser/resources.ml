open Util

let try_parse parser (name,path) =
  try
    if !Cli.verbose >= 2 then Printf.printf "Reading >%s< at path >%s<\n" name path;
    Yojson.Safe.from_file path
    |> parser
    |> Either.left
  with
  | Unsupported_Version v ->
    if !Cli.verbose >= 1 then Printf.printf "File %s uses unsupported version %s\n" name v; Either.right name
  | Invariant_violated v ->
    if !Cli.verbose >= 1 then Printf.printf "File %s violates invariant %s\n" name v; Either.right name

let count f xs =
  List.fold_left_map (fun (acc,xs) x -> match f x with Either.Left x -> ((acc,xs), Some x) | Either.Right name -> ((acc + 1, name :: xs),None)) (0,[]) xs
  ||> List.filter_map Fun.id

let meshes =
  lazy (Paths.meshes
        |> Lazy.force
        |> count (try_parse Mesh_int.parse))

let mesh_res refer = Resolver.resolve_mesh_ref (Lazy.force meshes |> snd) refer

let items =
  lazy (
    let ((fails,fail_names), items) =
      Paths.items
      |> Lazy.force
      |> (
        mesh_res
        |> Item_int.parse
        |> try_parse
        |> count)
    in
    let ((fails2, fail_names2), item_dups) =
       Paths.item_dups
        |> Lazy.force
        |> (
          Item_int.parse_dups (Resolver.resolve_item_ref items) mesh_res
          |> try_parse
          |> count)
    in
    ((fails + fails2, fail_names @ fail_names2), items @ item_dups))

let item_res refer = Resolver.resolve_item_ref (Lazy.force items |> snd) refer

let constructs_ftd =
  lazy (
    Paths.constructs_ftd
        |> Lazy.force
        |> (Construct_int.parse item_res mesh_res
          |> try_parse
          |> count)
        )

let constructs_personal =
  lazy (
    Paths.constructs_personal
        |> Lazy.force
        |> (Construct_int.parse item_res mesh_res
          |> try_parse
          |> count)
        )

let%expect_test "Parsing items" =
  let (fails, _) = Lazy.force items in
  [%show: (int * string list)] fails
  |> print_endline;
  [%expect{| (0, []) |}]

let%expect_test "Parsing constructs_personal" =
  let (fails, _) = Lazy.force constructs_personal in
  [%show: (int * string list)] fails
  |> print_endline;
  [%expect{|
    (12,
     ["Twin Laser.blueprint"; "Laser designated missiles.blueprint";
       "Laser designated (part 2 of 2).blueprint";
       "Laser designated (part 1 of 2).blueprint"; "IR missiles.blueprint";
       "HE CRAM.blueprint"; "Drill.blueprint"; "Beam rider missiles.blueprint";
       "Adv. IR missiles.blueprint"; "APS.blueprint"; "APS Ammo.blueprint";
       "APHE CRAM.blueprint"]) |}]

let%expect_test "Parsing constructs_ftd" =
  let (fails, _) = Lazy.force constructs_ftd in
  [%show: (int * string list)] fails
  |> print_endline;
  [%expect{|
    (357,
     ["90K_prop.blueprint"; "616_turbine.blueprint"; "36K_prop.blueprint";
       "3600_800_prop.blueprint"; "2925_turbine.blueprint";
       "180K_4_prop.blueprint"; "1384_turbine.blueprint";
       "FuelRefineryExample.blueprint"; "6x3x9BatteryElectric.blueprint";
       "Yogund Bomb Bay.blueprint"; "Spitfire Launcher.blueprint";
       "Skyrazor.blueprint"; "Siren Harpoon Battery.blueprint";
       "Silent Night VLS.blueprint"; "Porcupine Torpedo Launcher.blueprint";
       "Ninjin Box Turret.blueprint"; "Keelhaul Harpoon Launcher.blueprint";
       "Jet Hunter VLS.blueprint"; "Hornet Swarm Cluster Missile.blueprint";
       "Hawkeye Launcher.blueprint"; "Gravitas Bomb Bay.blueprint";
       "Cultist VLS.blueprint"; "Colossus Bomb Bay.blueprint";
       "Cavitator Cluster Torpedo.blueprint"; "Blazing Morning VLS.blueprint";
       "Basic VLS.blueprint"; "Lightburst Cannon.blueprint"; "ComPACt.blueprint";
       "3x3x27-4QLaserExample.blueprint"; "3x3x21LAMSExample.blueprint";
       "outbackfamilypro.blueprint"; "ecomax.blueprint";
       "7x7x9HarmonyDraba5000.blueprint"; "5x5x9EcoDraba4000.blueprint";
       "5x5x9Drabanator5000alternative.blueprint";
       "5x5x8Drabanator6000.blueprint"; "5x5x10EcoDraba3000.blueprint";
       "5x3x7HarmonyDraba6800.blueprint"; "3x7x10EcoDraba2000.blueprint";
       "3x3x9Drabanator5000.blueprint"; "smallwoodentug.blueprint";
       "metallargehull.blueprint"; "metalandalloysplithull.blueprint";
       "mediumwoodenhull.blueprint"; "mediumwoodencargohull.blueprint";
       "mandamediumhull.blueprint"; "alloymediumhull.blueprint";
       "ScoutTankFrame.blueprint"; "PropPlaneFrame.blueprint";
       "MetalTumblehomePartB.blueprint"; "MetalTumblehomePartA.blueprint";
       "MediumTankFrame.blueprint"; "JetFrame.blueprint";
       "HydrofoilExample.blueprint"; "HeavyTankFrame.blueprint";
       "Dreadnought Hull Front.blueprint"; "Dreadnought Hull Back.blueprint";
       "Bertha.blueprint"; "9x3x14 Broadside Battery A.blueprint";
       "7x3x14 Broadside Battery B.blueprint";
       "7x1x13 1200mm Flat Cannon.blueprint"; "1600mm Mortar.blueprint";
       "1100mm Quad-Mortar.blueprint"; "1-axis 1200mm Basic Cannon.blueprint";
       "1-Axis Mortar Turret.blueprint";
       "1-Axis 2000mm Morganus Doomcannon.blueprint";
       "1-Axis 1650mm Twin Elephant.blueprint";
       "1-Axis 1550mm Deck Howitzer.blueprint";
       "1-Axis 1400mm Twin Rhino.blueprint"; "7x3x7 DedibladeStack.blueprint";
       "5x5x12LargeCJEExample.blueprint"; "3x3x12SmallCJEExample.blueprint";
       "15x3x15 DedibladeStack.blueprint"; "11x3x11 DedibladeStack.blueprint";
       "9x9_Turret_Template.blueprint"; "9x9 Ruby.blueprint";
       "9x9 Citrin.blueprint"; "7x7 Zirconium.blueprint"; "5x5 Cuprum.blueprint";
       "5x5 Cobalt.blueprint"; "Mamba.blueprint"; "Copperhead.blueprint";
       "9x9_Turret_Template.blueprint"; "9x9Ruby.blueprint";
       "9x9Pearl.blueprint"; "9x9Citrin.blueprint";
       "7x7_Turret_Template.blueprint"; "7x7Zirconium.blueprint";
       "7x7Gallium.blueprint"; "5x5Cuprum.blueprint"; "5x5Cobalt.blueprint";
       "5x5Bromine.blueprint"; "17x17_Turret_Template.blueprint";
       "15x15_Turret_Template.blueprint"; "13x13_Turret_Template.blueprint";
       "11x11_Turret_Template.blueprint"; "NSmartiUltimate.blueprint";
       "NSmarti2000.blueprint"; "NSmarti1000.blueprint";
       "CIWSShellkinetic.blueprint"; "CIWSShellHE.blueprint";
       "CIWSShellFlak.blueprint"; "9x6x1RingShieldExample.blueprint";
       "3x3x4-MunitionWarners.blueprint"; "3x2x4LaserWarnerExample.blueprint";
       "1axis5x5ciws.blueprint"; "1axis3x3ciws.blueprint";
       "11x3x4StrategicAntenna.blueprint"; "Twin Laser.blueprint";
       "Laser designated missiles.blueprint";
       "Laser designated (part 2 of 2).blueprint";
       "Laser designated (part 1 of 2).blueprint"; "IR missiles.blueprint";
       "HE CRAM.blueprint"; "Drill.blueprint"; "Beam rider missiles.blueprint";
       "Adv. IR missiles.blueprint"; "APS.blueprint"; "APS Ammo.blueprint";
       "APHE CRAM.blueprint"; "spawnbeacon.blueprint"; "StingerMk3.blueprint";
       "StingerMk2.blueprint"; "Stinger.blueprint"; "Spike.blueprint";
       "Shiv.blueprint"; "SeaFlayer.blueprint"; "Scylla.blueprint";
       "Perdition.blueprint"; "ObeliskMk2.blueprint"; "MarrowPulper.blueprint";
       "Fracture.blueprint"; "FlayedMonasterymission.blueprint";
       "Flagellator.blueprint"; "Executioner.blueprint"; "Condemned.blueprint";
       "Carcharodon.blueprint"; "Bruiser.blueprint";
       "Bloodstone Fortress2.blueprint"; "Bloodstone Fortress.blueprint";
       "Thunder.blueprint"; "Sneek.blueprint"; "Sharktooth.blueprint";
       "Rain.blueprint"; "Panic.blueprint"; "Omen.blueprint"; "Neuron.blueprint";
       "Lightning.blueprint"; "Jipachi.blueprint"; "Jigabachi.blueprint";
       "Irritation.blueprint"; "Infinity.blueprint"; "Harbinger.blueprint";
       "Hail.blueprint"; "Eternal.blueprint"; "Enmity.blueprint";
       "Devastation.blueprint"; "Desolation.blueprint"; "Annihilation.blueprint";
       "VTOLDrone.blueprint"; "Trident.blueprint"; "Tower_unarmed.blueprint";
       "TorpedoBomberDrone.blueprint"; "Toad.blueprint"; "TargetBoat.blueprint";
       "Tadpole_Mk_I.blueprint"; "Spirit_Shielded.blueprint";
       "Se4sons.blueprint"; "SMSDaring.blueprint"; "Raptor_Jet.blueprint";
       "Raptor.blueprint"; "QuadCopterDrone.blueprint"; "Oracle.blueprint";
       "Novara.blueprint"; "Mining Rig.blueprint"; "Limbo.blueprint";
       "LAMSDrone.blueprint"; "Icarus.blueprint"; "Hammer.blueprint";
       "Gannus.blueprint"; "Fury.blueprint"; "Forward_Operating_Base.blueprint";
       "Exter.blueprint"; "Dromaeo.blueprint"; "Defiance.blueprint";
       "Bayonet.blueprint"; "Wraith.blueprint"; "Stardust.blueprint";
       "Scarlet Scythe.blueprint"; "Quasar.blueprint";
       "OmegaNightmare.blueprint"; "OLSC.blueprint"; "Nova.blueprint";
       "Nightmare.blueprint"; "Nebula.blueprint"; "Fusion.blueprint";
       "Flare.blueprint"; "DuskBlade.blueprint"; "Corona.blueprint";
       "Comet.blueprint"; "Calamity.blueprint"; "Bishop.blueprint";
       "Asteroid.blueprint"; "Anarchist.blueprint"; "raft_april.blueprint";
       "TutorialSteamEngine.blueprint"; "TutorialResourceFortress.blueprint";
       "TutorialMissile.blueprint"; "TutorialHelicopter.blueprint";
       "TutorialFuelEngine.blueprint"; "TutorialDetection.blueprint";
       "TutorialCRAM.blueprint"; "TutorialBasicsBoat.blueprint";
       "TutorialAi.blueprint"; "TargetVisual.blueprint"; "TargetSonar.blueprint";
       "TargetIR.blueprint"; "Seagull.blueprint"; "Pinacle.blueprint";
       "Palstave.blueprint"; "OWFoundry.blueprint"; "Jormungand.blueprint";
       "Hourglass.blueprint"; "Fairday.blueprint"; "Culverin.blueprint";
       "Constellation.blueprint"; "Churl.blueprint"; "Chancellor.blueprint";
       "Capitol.blueprint"; "Behemoth.blueprint"; "Bayleaf.blueprint";
       "Bailey.blueprint"; "anvilfactory.blueprint";
       "ForwardOperatingAirstrip.blueprint"; "Uropygi.blueprint";
       "Tetrode.blueprint"; "Tesla.blueprint"; "Teravolt.blueprint";
       "Tachyon.blueprint"; "Surge.blueprint"; "Streak.blueprint";
       "SeaRaptor.blueprint"; "Scorpion.blueprint"; "Razormaul.blueprint";
       "Polarity.blueprint"; "Ohm.blueprint"; "Nike.blueprint";
       "Mantis.blueprint"; "Inquisitor.blueprint"; "Incinerator.blueprint";
       "Iapetus.blueprint"; "Hypatos.blueprint"; "Dagger.blueprint";
       "CrossBolt.blueprint"; "Cathode.blueprint"; "Bifrost.blueprint";
       "BelugaElite.blueprint"; "Beluga.blueprint"; "Amplitude.blueprint";
       "nightjar.blueprint"; "Werebat.blueprint"; "Vulture.blueprint";
       "Stratocumulus.blueprint"; "Songbird.blueprint"; "Pelican.blueprint";
       "Osprey.blueprint"; "Odyssey.blueprint"; "Moskito.blueprint";
       "Latobius.blueprint"; "Kite Fighter.blueprint";
       "Iron_Juggernaut.blueprint"; "Iron Wolf.blueprint";
       "Iron Juggernaut.blueprint"; "Iron Curtain.blueprint";
       "Hummingbird.blueprint"; "Hermes.blueprint"; "HellRaven.blueprint";
       "Dragonfly.blueprint"; "Dragon.blueprint"; "Corruption.blueprint";
       "Convictor.blueprint"; "Bee.blueprint"; "Aeonic.blueprint";
       "Aardsnel.blueprint"; "WaterBuffalo.blueprint"; "Wanderlust.blueprint";
       "VanguardRetrofit.blueprint"; "Urchin.blueprint"; "TESTBalloon.blueprint";
       "Sunfish.blueprint"; "Submarauder.blueprint"; "Smallrauder.blueprint";
       "Sledge.blueprint"; "SkyViper.blueprint"; "Sinnersluck.blueprint";
       "Sinners_luck.blueprint"; "Singularauder.blueprint"; "SeaAdder.blueprint";
       "Ramrauder.blueprint"; "PaddlegunPrototype.blueprint"; "Ocelot.blueprint";
       "Mule.blueprint"; "Mrdr.blueprint"; "Mouth Marauder.blueprint";
       "Mecharauder.blueprint"; "Marauder_Old_Style.blueprint";
       "MarauderHomeRetrofit.blueprint"; "MarauderCargoRetrofit.blueprint";
       "Marauder Ravager.blueprint"; "Jet_Marauder.blueprint";
       "Javelin.blueprint"; "JacobsDelight.blueprint"; "Hotrauder.blueprint";
       "Hoplite.blueprint"; "HeliMarauder.blueprint";
       "Glass Cannon Marauder.blueprint"; "Firework Marauder.blueprint";
       "Discorauder.blueprint"; "Cockatrice.blueprint";
       "Brrrrrrtarauder.blueprint"; "Battlerauder.blueprint";
       "BabyPaddlegun.blueprint"; "Antlion.blueprint";
       "TutorialDrivingBoat.blueprint";
       "Tutorial Resource Fortress_Base.blueprint";
       "Tutorial Resource Fortress.blueprint"; "Tutorial Missiles.blueprint";
       "Tutorial Injector Engine.blueprint";
       "Tutorial Efficient Engine.blueprint"; "Tutorial CRAM_Base.blueprint";
       "Tutorial CRAM.blueprint"; "Tutorial Boat Painted.blueprint";
       "Tutorial All AI.blueprint"; "Prefab Fortress.blueprint";
       "Our Boat.blueprint"; "GuideTemplate.blueprint"; "Guide Sails.blueprint";
       "Guide Resources.blueprint"; "Guide Plane.blueprint";
       "Guide Missiles.blueprint"; "Guide Materials.blueprint";
       "Guide Lasers.blueprint"; "Guide Fuel.blueprint";
       "Guide Fuel Engine.blueprint"; "Guide Electric Engine.blueprint";
       "Guide Drill.blueprint"; "Guide Detection.blueprint";
       "Guide Custom Jet.blueprint"; "Guide Boat Building.blueprint";
       "Guide Ammo.blueprint"; "Guide APS.blueprint"; "Guide AI.blueprint";
       "CIWS.blueprint"; "AA Fortress.blueprint"; "Noogai Radar Drone.blueprint";
       "Juggler.blueprint"; "404.blueprint"]) |}]

let rec compare_json node t u =
  match (t,u) with
   ((`Assoc _ as t), (`Assoc _ as u)) ->
  Yo.Util.(
    let keys_t = List.sort String.compare (keys t) in
    let keys_u = List.sort String.compare (keys u) in
    if List.compare String.compare keys_t keys_u != 0 then failwith (Printf.sprintf "Node: %s failed with keys:\n%s\n%s\n" node ([%show: string list] keys_t) ([%show: string list] keys_u));
    List.fold_left (fun acc kt -> acc && compare_json (node ^ kt) (member kt t) (member kt u)) true keys_t
  )
  | (x,y) -> Yo.equal x y

(* let%test "Construct: FtD <-> Internal" =
 *   let (_, cons) =
 *     Paths.constructs_ftd
 *     |> Lazy.force
 *     |> count (try_parse Construct_ftd.t_of_yojson)
 *   in
 *   cons
 *   |> List.map (fun construct ->
 *       let cons = Construct_ftd.yojson_of_t construct in
 *       let cons' =
 *         construct
 *         |> Construct_int.cons_int_of_ftd
 *         |> Construct_int.cons_ftd_of_int
 *         |> Construct_ftd.yojson_of_t
 *       in
 *       if compare_json (construct.name |> Option.value ~default:"Unnamed") cons cons'
 *       then true
 *       else (Printf.printf "Incorrect conversion for original construct:\n%s\n\nand converted construct:\n%s\n" (Yo.show cons) (Yo.show cons'); raise Generic))
 *   |> List.fold_left (&&) true *)
