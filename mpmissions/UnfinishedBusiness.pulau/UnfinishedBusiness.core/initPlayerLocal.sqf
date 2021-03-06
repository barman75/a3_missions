/***************************************************************************
 *   Copyright (C) 2008-2019 by Oleksii S. Malakhov <brezerk@gmail.com>    *
 *                                                                         *
 *   This program is free software: you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation, either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>. *
 *                                                                         *
 ***************************************************************************/

/*
Local player script
*/

//variables
informator_told = false;
west_order_seen = false;
east_order_seen = false;
indep_order_seen = false;
civ_order_seen = false;


#include "..\config\fractions.sqf";

Fn_Local_WaitPublicVariables = {
	params ['_vars'];
	private _done = true;
	{
		if (isNil _x) then { _done = false; };
	} forEach _vars;
	_done;
};

// hide markers
if (isServer) then {
	{if (_x find "wp_" >= 0) then {_x setMarkerAlphaLocal 0;}} forEach allMapMarkers;
} else {
	{if (_x find "wp_" >= 0) then {_x setMarkerAlphaLocal 0;}} forEach allMapMarkers;
};

{if (_x find "respawn_" >= 0) then {_x setMarkerAlphaLocal 0;}} forEach allMapMarkers;

waitUntil { !isNull player }; // Wait for player to initialize

cutText ["", "BLACK"];

waitUntil { sleep 1; [["mission_requested", "mission_generated", "mission_plane_send", "us_liberty_01", "mission_plane_send_time", "mission_plane_down_time", "mission_plane_pass_count", "obj_specops_target"]] call Fn_Local_WaitPublicVariables; };

if ((!mission_requested) || (!mission_generated)) then {
	["UnfinishedBusiness.core\ui\settingsDialog.sqf"] call BrezBlock_fnc_WaitForStart;
};

waitUntil { sleep 1; [["D_LOCATION", "D_FRACTION_WEST", "D_FRACTION_EAST", "D_FRACTION_CIV", "D_FRACTION_INDEP", "D_NAVTOOL_MAP", "D_NAVTOOL_COMPASS"]] call Fn_Local_WaitPublicVariables; }; 

Fn_Local_Init_Spawn = {

	if ((side player) == west) then {
		if (player getVariable ["is_civilian", false]) then {
			player setVariable ["weapon_fiered", false, true];
			[civilian] call Fn_Local_Switch_Side;
		};
	};

	switch ((side player)) do {
		case east: {
			[] execVM "UnfinishedBusiness.core\gear\player\east.sqf";
			private _pos = [(getMarkerPos "respawn_east"), 5, 20, 3, 0, 0, 0] call BIS_fnc_findSafePos;
			player setPos _pos;
		};
		case civilian: {
			player setVariable ["is_civilian", true, true];
			player setVariable ["weapon_fiered", false, false];
			[] execVM "UnfinishedBusiness.core\gear\player\civ.sqf";
			private _pos = [(getMarkerPos "respawn_civ"), 5, 20, 3, 0, 0, 0] call BIS_fnc_findSafePos;
			player setPos _pos;
		};
		case west: {
			private _role = (roleDescription player);
			execVM "UnfinishedBusiness.core\gear\player\init.sqf";
			if (((_role find "SpecOps ") >= 0) && (!mission_plane_send)) then {
				private _pos = getMarkerPos "mrk_west_specops";
				"mrk_west_specops" setMarkerAlphaLocal 1;
				"mrk_west_specops" setMarkerTextLocal (localize "INFO_SUBLOC_11");
				player setPosATL [((_pos select 0) + (round(random 5) - 5)), ((_pos select 1) + (round(random 5) - 5)), 0];
			} else {
				"mrk_west_base_01" setMarkerAlphaLocal 1;
				player setPosASL (us_liberty_01 modelToWorldWorld [(round(random 5) - 5), (35 + (round(random 5) - 4)), 8.98]);
			};
			
			//0 = [player, "SupplyRequest"] call BIS_fnc_addCommMenuItem;
		};
	};
};



player setVariable ["weapon_fiered", false, false];
player setVariable ["is_civilian", false, true];
player setVariable ["BB_CorpseTTL", -1, true];

call Fn_Local_Init_Spawn;

{
	private _pos = getMarkerPos _x;
    {
		_x addAction 
		[
			localize "ACTION_12", 
			{
				[] execVM "UnfinishedBusiness.core\ui\orderDialog.sqf";
			},
			[],
			1.5, 
			true, 
			true, 
			"",
			"", // _target, _this, _originalTarget
			3
		];
	} forEach (_pos nearObjects ["Land_MapBoard_F", 50]);
} forEach ["mrk_west_specops", "respawn_east", "respawn_west"];

[1, "BLACK", 1, 1] call BIS_fnc_fadeEffect;
cutText [localize "INFO_WAIT_02", "PLAIN DOWN", 2, true, true];
[[""]] call BIS_fnc_music;

[] execVM "UnfinishedBusiness.core\briefing.sqf";


#include "missions\local\intro.sqf";
#include "missions\local\fast_travel.sqf";
#include "missions\local\jet_is_down.sqf";
#include "missions\local\informator.sqf";
#include "missions\local\west\aa.sqf";
#include "missions\local\west\commtower.sqf";
#include "missions\local\west\intel.sqf";
#include "missions\local\west\intro.sqf";
#include "missions\local\leader.sqf";
#include "missions\local\east.sqf";
#include "missions\local\west.sqf";
#include "missions\local\cargo.sqf";
#include "missions\local\crash_site.sqf";
#include "missions\local\rescue.sqf";
#include "missions\civilian\liberate.sqf";
#include "missions\local\regroup.sqf";
#include "missions\local\recruit.sqf";
#include "missions\local\independent\objectives.sqf";
#include "missions\local\civilian\confiscate.sqf";
#include "missions\local\civilian\intro.sqf";

/*
*/

{
	private _mark = createMarkerLocal [(format ['mrk_em_%1', _forEachIndex]), (getMarkerPos _x)];
	_mark setMarkerType "hd_objective";
	_mark setMarkerTextLocal format [localize "INFO_WEST_SAFESPOT_01", (['A', 'B'] select _forEachIndex)];
	_mark setMarkerColorLocal "ColorWEST";
	if (((roleDescription player find "SpecOps ") >= 0) && (!mission_plane_send)) then {
		_mark setMarkerAlphaLocal 0;
	};
} forEach ['mrk_east_stash_01', 'mrk_east_stash_02'];

/* FIXME: CBA-only
execVM "addons\BrezBlock.framework\utils\marker_manager.sqf";
 */
 
// Disable BIS Revive system if ACE Medical mod is loaded
if (D_MOD_ACE_MEDICAL) then {
	[player] call BIS_fnc_disableRevive;
};

//ACE Specator
if (D_MOD_ACE) then {
	[1, objNull] call ace_spectator_fnc_setCameraAttributes;
	[[west], [east,civilian]] call ace_spectator_fnc_updateSides;
	
	//Document check
	_action = [
		"bb_document_check",
		localize "STR_ACTION_DOC_CHECK",
		"",
		{
			params ["_target", "_player", "_params"];
			[(side _target)] execVM "UnfinishedBusiness.core\ui\idDialog.sqf";
		},
		{true},
		{},
		[],
		"",
		5,
		[false, false, false, false, false]] call ace_interact_menu_fnc_createAction;
	
	["CAManBase", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
};
 
Fn_Local_SetPersonalTaskState = {
	params['_name', '_state', '_title'];
	private _task = [_name, player] call BIS_fnc_taskReal;
	if (!isNull _task) then {
		[format["Task%1", _state],["", _title]] call BIS_fnc_showNotification;
		_task setTaskState _state;
	};
};

Fn_Local_FailTasks = {
	private ['_task'];
	{
		_task = [_x, player] call BIS_fnc_taskReal;
		if (!isNull _task) then {
			if (!(([_x] call BIS_fnc_taskState) in ["FAILED", "SUCCEEDED"])) then {
				[_x, "CANCELED", false] call BIS_fnc_taskSetState;
				//[_x, player] call BIS_fnc_deleteTask;
			};
		};
	} forEach [
		't_WEST_crash_site',
		't_WEST_01_crash_site',
		't_regroup',
		't_west_rescue',
		't_west_destroy_windmill',
		't_west_destroy_fuel',
		't_west_kill_doctor',
		't_west_destroy_ammo',
		't_west_extract',
		't_find_informator',
		't_arrive_to_island'
	];
};

Fn_Local_CheckIfCivPlayerDetected = {
	private['_detected'];
	_detected = false;
	if (player getVariable ["is_civilian", false]) then {
		if (!(player getVariable ["weapon_fiered", false])) then {
			{
				if ((_x knowsAbout player) > 0) exitWith {
					_detected = true;
				};
			} forEach nearestObjects [player, ["SoldierEB", "SoldierGB", "SoldierWB"], 800];
		};
	};
	_detected;
};

Fn_Local_Switch_Side = {
	params['_side'];
	private _player = player; 
	[player] joinSilent createGroup [_side, true];
	selectNoPlayer; 
	selectPlayer _player;
};



player addEventHandler
[
	"Killed",
	{
		private _respawnDelay = D_RESPAWN_DELAY;
		setPlayerRespawnTime (_respawnDelay - (servertime % _respawnDelay));
		[[1,2], [0]] call ace_spectator_fnc_updateCameraModes;
		if ((side player) == west) then {
			if (player getVariable ["is_civilian", false]) then {
				player setVariable ["weapon_fiered", false, true];
				[civilian] call Fn_Local_Switch_Side;
				if (D_MOD_ACE) then { [[civilian], [east,west]] call ace_spectator_fnc_updateSides; };
			} else {
				if ((player getVariable ["is_assault_group", false]) || (player getVariable ["is_specops_group", false])) then {
				
					
					
					private _side = objNull;
					
					private _sides = [civilian, east, west];
						
					if (!(alive obj_east_comtower)) then {
						_sides = _sides - [east];
					} else {
						private _all_count = {alive _x} count (playableUnits + switchableUnits);
						private _east_count = {side _x == east && alive _x} count (playableUnits + switchableUnits);
						//systemChat format ["%1 of % 1 are east", _east_count, _all_count];
						if (_east_count >= (floor(_all_count / 4))) then {
							//systemChat "Removing east";
							_sides = _sides - [east];
						};
					};

					if (count _sides > 2) then {
						_sides = _sides - [(side player)];
					};
						
					_side = selectRandom _sides;

					switch (_side) do {
						case east:
						{
							//systemChat "switched";
							[east] call Fn_Local_Switch_Side;
							if (D_MOD_ACE) then { [[east], [west,civilian]] call ace_spectator_fnc_updateSides; };
						};
						case civilian:
						{
							//systemChat "switched";
							[civilian] call Fn_Local_Switch_Side;
							if (D_MOD_ACE) then { [[civilian], [east,west]] call ace_spectator_fnc_updateSides; };
							
						};
						case west:
						{
							//systemChat "switched";
							[west] call Fn_Local_Switch_Side;
							if (D_MOD_ACE) then { [[west], [east,civilian]] call ace_spectator_fnc_updateSides; };
						};
					};
				};
			};
		};
	}
];

player addEventHandler
[
   "Respawn",
   {
		if (mission_plane_send) then {
			if (player getVariable ["is_assault_group", false]) then {
				player setVariable ["is_assault_group", false, true];
				call Fn_Local_FailTasks;
				call Fn_Local_Create_Mission_CrashSite;
			};
			if (player getVariable ["is_specops_group", false]) then {
				player setVariable ["is_specops_group", false, true];
				call Fn_Local_FailTasks;
				call Fn_Local_Create_Mission_CrashSite;
			};
			
			if ((side player) == west) then {
				if (player getVariable ["is_civilian", false]) then {
					player setVariable ["weapon_fiered", false, true];
					[civilian] call Fn_Local_Switch_Side;
				};
			};
			
			switch ((side player)) do
			{
				case east:
				{
					"mrk_west_base_01" setMarkerAlphaLocal 0;
					"mrk_west_specops" setMarkerAlphaLocal 0;
					"mrk_west_safezone_01" setMarkerAlphaLocal 0;
					"mrk_east_stash_01" setMarkerAlphaLocal 0;
					"mrk_east_stash_02" setMarkerAlphaLocal 0;
					[] execVM "UnfinishedBusiness.core\gear\player\east.sqf";
					player setPos getMarkerPos "respawn_east";
					call Fn_Local_Create_EAST_MissionIntro;
				};
				case civilian:
				{
					"respawn_civ" setMarkerTextLocal (localize "INFO_SUBLOC_12");
					"respawn_civ" setMarkerAlphaLocal 1;
					"mrk_west_base_01" setMarkerAlphaLocal 0;
					"mrk_west_specops" setMarkerAlphaLocal 0;
					"mrk_west_safezone_01" setMarkerAlphaLocal 0;
					"mrk_east_stash_01" setMarkerAlphaLocal 0;
					"mrk_east_stash_02" setMarkerAlphaLocal 0;
					player setVariable ["is_civilian", true, true];
					player setVariable ["weapon_fiered", false, false];
					[] execVM "UnfinishedBusiness.core\gear\player\civ.sqf";
					/*
					private _civ_spawn_markers = [];
					{
						if (_x find "respawn_civilian_" >= 0) then {
							_civ_spawn_markers pushBack _x;
						};
					} forEach allMapMarkers;
					*/
					
					private _pos = [(getMarkerPos "respawn_civ"), 5, 20, 3, 0, 0, 0] call BIS_fnc_findSafePos;
					player setPos _pos;
					//player setPos (getMarkerPos "respawn_civ");
					call Fn_Local_Create_Task_Civilian_FloodedShip;
					call Fn_Local_Create_Task_Civilian_WaponStash;
					//call Fn_Local_Create_Task_Civilian_Police;
					call Fn_Local_Create_Task_Civilian_Liberate_MissionIntro;
				};
				case west:
				{
					[] execVM "UnfinishedBusiness.core\gear\player\init.sqf";
					player setPosASL (us_liberty_01 modelToWorldWorld [(round(random 5) - 5), (35 + (round(random 5) - 4)),8.98]);
					call Fn_Local_Create_RescueMission;
				};
			};
		} else {
			call Fn_Local_Init_Spawn;
		};
		player setVariable ["BB_CorpseTTL", -1, true];
   }
];

player addEventHandler [
	"GetInMan", 
	{
		params ["_unit", "_role", "_vehicle", "_turret"];
		if ((side player) == civilian) then {
			private _v_side = side _vehicle;
			if ((_v_side == east) or (_v_side == independent)) then {
				//player setVariable ["is_civilian", false, true];
				hint (parseText (format ["<t size='2.0'>%1</t>", localize "INFO_CIV_WARNING_03"]));
				[west] call Fn_Local_Switch_Side;
				doGetOut player;
			};
		};
	}
];

player addEventHandler [
	"InventoryOpened",
	{
		params ["_unit", "_container"];
		if ((side player) == civilian) then {
			private _v_side = side _container;
			if ((_v_side == east) or (_v_side == independent)) then {
				//player setVariable ["is_civilian", false, true];
				hint (parseText (format ["<t size='2.0'>%1</t>", localize "INFO_CIV_WARNING_03"]));
				[west] call Fn_Local_Switch_Side;
			};
		};
	}
];

player addEventHandler
[
    "Take",
    {
		if ((side player) == civilian) then {
			if (!(player getVariable ["weapon_fiered", false])) then {
				if (primaryWeapon player != "" || secondaryWeapon player != "" || handgunWeapon player != "") then {
					[west] call Fn_Local_Switch_Side;
					hint (parseText (format ["<t size='2.0'>%1</t>", localize "INFO_CIV_WARNING_01"]));
					trgCivPlayerDetected = createTrigger ["EmptyDetector", getPos player];
					trgCivPlayerDetected setTriggerArea [0, 0, 0, false];
					trgCivPlayerDetected setTriggerActivation ["NONE", "PRESENT", false];
					trgCivPlayerDetected setTriggerStatements [
						"call Fn_Local_CheckIfCivPlayerDetected;",
						"player setVariable ['weapon_fiered', true, false]; deleteVehicle trgCivPlayerDetected; hint (parseText (format [""<t size='2.0'>%1</t>"", localize 'INFO_CIV_WARNING_03']));",
						""
					];
				};
			};
		};
    }
];

player addEventHandler
[
    "Put",
    {
		if (player getVariable ["is_civilian", false]) then {
			if (!(player getVariable ["weapon_fiered", false])) then {
				if (primaryWeapon player == "" && secondaryWeapon player == "" && handgunWeapon player == "") then {
					[civilian] call Fn_Local_Switch_Side;
					hint (parseText (format ["<t size='2.0'>%1</t>", localize "INFO_CIV_WARNING_04"]));
					deleteVehicle trgCivPlayerDetected;
				};
			};
		};
    }
];

/*
if (!D_MOD_ACE_MEDICAL) then {
	// Custom Revive system enabled
	test_001 addEventHandler
	[
		"HandleDamage",
		{
			params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
			if ( lifeState _unit != "INCAPACITATED" ) then {
				// Check body part
				if !(_selection in ["arms", "hands", "legs"]) then {
					// Check if fatal?
					if (_damage >= 1) then {
						if (local _unit) then {
							_unit setVariable ["BB_Uncsious", true, true];
							[_unit, ''] remoteExec ['playMoveNow'];
							_unit setUnconscious true;
							//_unit allowDamage false;
							//_unit spawn G_fnc_enterIncapacitatedState;
						};
						//Output new, non-fatal damage value
						_damage = 0.99;
					} else {
						//pass as is
						_damage;
					};
				};
			} else {
				_damage = 0;
			};
			_damage;
		}
	];
};
*/

execVM "UnfinishedBusiness.core\missions\local\sync.sqf";

sleep 5;

switch ((side player)) do {
	case west: {
		if (((roleDescription player find "SpecOps ") >= 0) && (!mission_plane_send)) then {
			[ format [localize 'INFO_LOC_01', D_LOCATION], localize 'INFO_SUBLOC_11', format [localize 'INFO_DATE_01', daytime call BIS_fnc_timeToString], mapGridPosition player ] spawn BIS_fnc_infoText;
		} else {
			[ format [localize 'INFO_LOC_01', D_LOCATION], localize 'INFO_SUBLOC_00', format [localize 'INFO_DATE_01', daytime call BIS_fnc_timeToString], mapGridPosition player ] spawn BIS_fnc_infoText;
		};
	};
};
