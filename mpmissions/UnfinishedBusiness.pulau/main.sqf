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

real_weather_init = false;

[] execVM "addons\code43\real_weather.sqf";

if (isServer) then {
	_westHQ = createCenter west;
	_eastHQ = createCenter east;
	_indepHQ = createCenter independent;
	_civilianHQ = createCenter civilian;
	
	//make east and independent friends
	EAST setFriend [independent, 1];
	independent setFriend [EAST, 1];
	
	//make independent and west enemies
	WEST setFriend [independent, 0];
	independent setFriend [WEST, 0];
	
	//Set east and west sides to friends.
	//b/c friendship is a magic!
	EAST setFriend [WEST, 1];
	WEST setFriend [EAST, 1];
	
	s_west_group = createGroup west; publicVariable "s_west_group";
	s_east_group = createGroup east; publicVariable "s_east_group";
	s_indep_group = createGroup independent; publicVariable "s_indep_group";
	s_civ_group = createGroup civilian; publicVariable "s_civ_group";
	
	// Defaines (should be an UI option at mission startup);
	D_DIFFICLTY = 0; //0 easy, 1 medium, 2 hard
	D_FRACTION_INDEP = "CUP_I_NAPA"; //posible CUP_I_TK_GUE, IND_F, IND_F, IND_G_F
	
	D_LOCATION = "Gurun"; //selectRandom ["Gurun", "Monyet"];

	// Global variables
	
	pings = [];
	
	assault_group = [];
	vehicle_confiscate_group = [];
	vehicle_refuel_group = [];
	vehicle_patrol_group = [];
	
	//POIs
	avaliable_locations = [];
	avaliable_pois = [];

	Fn_Endgame = {
		params["_endingType"];
		if (isServer) then {
			_endingType call BIS_fnc_endMissionServer;
		};
	};

	Fn_Endgame_Loss = {
		if (isServer) then {
			//['t_defend_blockpost', 'FAILED'] call BIS_fnc_taskSetState;
			"EveryoneLost" call BIS_fnc_endMissionServer;
		};
	};

	Fn_Endgame_Win = {
		if (isServer) then {
			"EveryoneWon" call BIS_fnc_endMissionServer;
		};
	};
	
	Fn_Endgame_EvacPoint = {
		if (alive csat_comm_tower_01 || alive csat_aa_01) then {
			"EndAssaultGroupResqued_EASTWon_GUERWon" call Fn_Endgame;
		} else {
			"EndAssaultGroupResqued_EASTDefited_GUERWon" call Fn_Endgame;
		};
	};
	
	Fn_Endgame_LeaderKilled = {
		if (alive csat_comm_tower_01 || alive csat_aa_01) then {
			"EndAssaultGroupResqued_EASTWon_GUERDefited" call Fn_Endgame;
		} else {
			"EndAssaultGroupResqued_EASTDefited_GUERDefited" call Fn_Endgame;
		};
	};
	
	Fn_Spawn_UAZ = {
        params ["_spawnposition"];
        private ["_pos", "_vec"];
        _vec = objNull;
        if (isServer) then {
                _vec = selectRandom [
                        "CUP_O_UAZ_Unarmed_SLA",
                        "CUP_O_UAZ_Militia_SLA",
                        "CUP_O_UAZ_Open_SLA",
                        "CUP_O_UAZ_MG_SLA",
                        "CUP_O_UAZ_AGS30_SLA",
						"CUP_O_UAZ_SPG9_SLA",
						"CUP_O_UAZ_METIS_SLA"
                ];
                _pos = getMarkerPos _spawnposition findEmptyPosition [0, 15, _vec];
                _vec = createVehicle [_vec, _pos, [], 0];
                _vec setDir (markerDir _spawnposition);

        };
        _vec;
	};

	#include "missions\patrols.sqf";
	#include "missions\intro.sqf";
	#include "missions\aa.sqf";
	#include "missions\leader.sqf";
	#include "missions\civilian\cargo.sqf";
	
	waitUntil {real_weather_init};
	
	// skip random time
	skipTime ((random 5) + 6);
	
	sleep 2;
	
	call Fn_Create_MissionIntro;
	
	private _markers = [];
	{
		if (_x find format["wp_jet_crash_%1", D_LOCATION] >= 0) then {
			_markers pushBack _x;
		};
	} forEach allMapMarkers;
	
	//Create crash site marker
	private _crashSitePos = getMarkerPos (selectRandom _markers);
	private _mark = createMarker ["wp_crash_site", _crashSitePos];
	_mark setMarkerType "hd_destroy";
	_mark setMarkerAlpha 0;
	
	private _ret = [_crashSitePos, 3000, 3] call BrezBlock_fnc_GetAllCitiesInRange;
	//Get all POI in the range of 3000m
	avaliable_locations = _ret select 0;
	avaliable_pois = _ret select 1;
	
	publicVariable "avaliable_pois";
	
	[_crashSitePos, 900] execVM "addons\brezblock\utils\controller.sqf";
	execVM "missions\create_locations.sqf";
	[getMarkerPos "wp_aa", 600] execVM "addons\brezblock\utils\controller.sqf";
	[getMarkerPos "wp_air_field_Gurun_01", 600] execVM "addons\brezblock\utils\controller.sqf";
	
	[Fn_Spawn_UAZ, 'wp_spawn_uaz_01', 20, 10] execVM 'addons\brezblock\triggers\respawn_transport.sqf';
	[Fn_Spawn_UAZ, 'wp_spawn_uaz_02', 20, 10] execVM 'addons\brezblock\triggers\respawn_transport.sqf';
	
			//spawn creater and wreck
			//"Crater" createVehicle (_markerPos); 
			//private _obj = "Land_Wreck_Traw_F" createVehicle ([((_markerPos select 0) - 5), ((_markerPos select 1) + 20), 0]); 
			//_obj = "Land_Wreck_Traw2_F" createVehicle ([((_markerPos select 0) - 5), ((_markerPos select 1) - 10), 0]); 
			
	//[_markerPos] call Fn_Task_Civilian_FloodedShip_SpawnRandomCargo;
	
	
	addMissionEventHandler ["EntityKilled",
	{
		params ["_killed", "_killer", "_instigator"];
		private _ace_kill = _killed getVariable "ace_medical_lastDamageSource";
		if (!isNil "_ace_kill") then {
			if (isPlayer _ace_kill) then {
				if ((side _ace_kill) == civilian) then {
					_ace_kill setVariable ["is_civilian", false, true];
					[west] remoteExec ["Fn_Local_Switch_Side", _ace_kill];
				};
			};
			[format ["Killed ACE by %1", name _ace_kill]] remoteExec ["systemChat"];
		};
	}];
	
	
};

// We need to end game if all players are no longer alive
//[] execVM "addons\brezblock\triggers\end_game.sqf";
