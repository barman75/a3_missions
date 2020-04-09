class BrezBlock
{
	class common
	{
		class PopulateBaseSupply {file = "addons\BrezBlock.framework\utils\populate_base_supply.sqf";};
		class WaitForStart {file = "addons\BrezBlock.framework\utils\wait_for_start.sqf";};
		class Get_RND_Index {file = "addons\BrezBlock.framework\utils\get_rnd_index.sqf";};
		class Attach_Hold_Action {file = "addons\BrezBlock.framework\actions\attach_hold.sqf";};
		class Attach_SearchIntel_Action {file = "addons\BrezBlock.framework\actions\attach_intel.sqf";};
		class CreateCivilianPresence {file = "addons\BrezBlock.framework\systems\civilian.sqf";};
		class CreateCivilianSupply {file = "addons\BrezBlock.framework\systems\supply_civilian.sqf";};
		class CreateCivilianHospital {file = "addons\BrezBlock.framework\systems\hospital_civilian.sqf";};
		class CreatePatrol {file = "addons\BrezBlock.framework\systems\patrol.sqf";};
		class MarkerCreatePatrol {file = "addons\BrezBlock.framework\systems\marker_patrol.sqf";};
		class CreateDefend {file = "addons\BrezBlock.framework\systems\defend.sqf";};
		class CreateGarrison {file = "addons\BrezBlock.framework\systems\garrison.sqf";};
		class MarkerCreateDefend {file = "addons\BrezBlock.framework\systems\marker_defend.sqf";};
		class CreateCheckPoint {file = "addons\BrezBlock.framework\systems\checkpoint.sqf";};
		class CreateArmor {file = "addons\BrezBlock.framework\systems\armor.sqf";};
		class GetRandomCity {file = "addons\BrezBlock.framework\utils\get_random_city.sqf";};
		class GetAllCitiesInRange {file = "addons\BrezBlock.framework\utils\get_cities.sqf";};
		class GetAllMarkerTypesInRange {file = "addons\BrezBlock.framework\utils\get_all_marker_types_in_range.sqf";};
		class GetEmptyRoads {file = "addons\BrezBlock.framework\utils\get_empty_roads.sqf";};
		class CotrollerCreate {file = "addons\BrezBlock.framework\utils\controller.sqf";};
		class SpawnObjects {file = "addons\BrezBlock.framework\utils\spawn_objects.sqf";};
		class Spawn_Objective {file = "addons\BrezBlock.framework\utils\spawn_objective.sqf";};
		class Spawn_Destroyer {file = "addons\BrezBlock.framework\utils\spawn_destroyer.sqf";};
		//class Spawn_OPFOR_Forces {file = "addons\BrezBlock.framework\utils\spawn_opfor_forces.sqf";};
		class Spawn_OPFOR_Forces {file = "addons\BrezBlock.framework\utils\spawn_opfor_forces_v2.sqf";};
		class Spawn_OPFOR_Forces_Guard {file = "addons\BrezBlock.framework\utils\spawn_opfor_forces_guard.sqf";};
		class Systems_Refuel_Init {file = "addons\BrezBlock.framework\systems\refuel\init.sqf";};
		class Local_Systems_Refuel_Refuel {file = "addons\BrezBlock.framework\systems\refuel\refuel.sqf";};
		class Local_Systems_Refuel_Drain {file = "addons\BrezBlock.framework\systems\refuel\drain.sqf";};
		class Local_Systems_Refuel_Check {file = "addons\BrezBlock.framework\systems\refuel\check.sqf";};
		class Systems_Cargo_Init {file = "addons\BrezBlock.framework\systems\cargo\init.sqf";};
		class Local_Systems_Cargo_Load {file = "addons\BrezBlock.framework\systems\cargo\load.sqf";};
		class Local_Systems_Cargo_Unload {file = "addons\BrezBlock.framework\systems\cargo\unload.sqf";};
		class Systems_Refuel_Station {file = "addons\BrezBlock.framework\systems\refuel\station.sqf";};
		class Utils_Garbage_Collector {file = "addons\BrezBlock.framework\utils\garbage_collector.sqf";};
		class Local_Systems_Fuel_Init {file = "addons\BrezBlock.framework\systems\fuel\init.sqf";};
		class Local_Systems_Radiation_Local {file = "addons\BrezBlock.framework\systems\threats\radiation\local.sqf";};
		class Local_Systems_Radiation_Controller {file = "addons\BrezBlock.framework\systems\threats\radiation\controller.sqf";};
		class Local_Systems_Chemical_Local {file = "addons\BrezBlock.framework\systems\threats\chemical\local.sqf";};
		class Local_Systems_Chemical_Areal {file = "addons\BrezBlock.framework\systems\threats\chemical\areal.sqf";};
		class Local_Systems_Chemical_Controller {file = "addons\BrezBlock.framework\systems\threats\chemical\controller.sqf";};
		class Local_Systems_Detector_Radiation {file = "addons\BrezBlock.framework\systems\threats\detector\rad.sqf";};
		class Local_Systems_Detector_Chemical {file = "addons\BrezBlock.framework\systems\threats\detector\chem.sqf";};
		class Local_Systems_GasMask_Init {file = "addons\BrezBlock.framework\systems\threats\gasmask\init.sqf";};
		class Local_Systems_Survival_Init {file = "addons\BrezBlock.framework\systems\survival\player.sqf";};
		class Local_Systems_Survival_Fireplace {file = "addons\BrezBlock.framework\systems\survival\fireplace\init.sqf";};
		class Local_Systems_Survival_Fireplace_Spawn {file = "addons\BrezBlock.framework\systems\survival\fireplace\fireplace.sqf";};
		class Local_Systems_Survival_Fireplace_Despawn {file = "addons\BrezBlock.framework\systems\survival\fireplace\despawn.sqf";};
		class Local_Systems_Survival_Medical {file = "addons\BrezBlock.framework\systems\survival\medical\init.sqf";};
		class Local_Systems_Survival_Medical_Diag {file = "addons\BrezBlock.framework\systems\survival\medical\diag.sqf";};
		class Local_Systems_Survival_Medical_Rad {file = "addons\BrezBlock.framework\systems\survival\medical\threat_rad.sqf";};
		class Local_Systems_Survival_Medical_Toxine {file = "addons\BrezBlock.framework\systems\survival\medical\threat_toxine.sqf";};
		class Local_Systems_Survival_Medical_Flue {file = "addons\BrezBlock.framework\systems\survival\medical\threat_flue.sqf";};
		class call_diag {file = "addons\BrezBlock.framework\systems\survival\medical\diag_handler.sqf";};
		class callback_diag {file = "addons\BrezBlock.framework\systems\survival\medical\diag_call.sqf";};
		class call_derad {file = "addons\BrezBlock.framework\systems\survival\medical\call_derad.sqf";};
		class call_dechem {file = "addons\BrezBlock.framework\systems\survival\medical\call_dechem.sqf";};
		class call_debac {file = "addons\BrezBlock.framework\systems\survival\medical\call_debac.sqf";};
		class Local_Systems_Survival_Medical_Stimpack {file = "addons\BrezBlock.framework\systems\survival\medical\stimpack.sqf";};
	};
};
