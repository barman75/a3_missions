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
Informator side-mission code
*/

// Client side code
if (hasInterface) then {
	private ["_trg"];
	_trg = createTrigger ["EmptyDetector", getMarkerPos "wp_info_meetup_01"];
	_trg setTriggerArea [120, 120, 0, false];
	_trg setTriggerActivation ["ANYPLAYER", "PRESENT", true];
	_trg setTriggerStatements [
		"(vehicle player) in thisList",
		"[ localize 'INFO_LOC_01', localize 'INFO_SUBLOC_07', format [localize 'INFO_DATE_01', daytime call BIS_fnc_timeToString], mapGridPosition player ] spawn BIS_fnc_infoText;",
		""
	];
	
	Fn_Local_Task_Create_Informator = {
		[
			player,
			"t_info_meetup",
			[format [localize "TASK_08_DESC", name _obj],
			localize "TASK_08_TITLE",
			localize "TASK_ORIG_02"],
			getMarkerPos "wp_info_meetup_01",
			"CREATED",
			0,
			true
		] call BIS_fnc_taskCreate;
		['t_info_meetup', "talk"] call BIS_fnc_taskSetType;
	};
	
	Fn_Local_Task_Create_Informator_BlockpostAttack = {
		[
			player,
			["t_doc_01", "t_doc_search"],
			[
				localize "TASK_20_DESC",
				localize "TASK_20_TITLE",
				localize "TASK_ORIG_02"
			],
			getPos p_officer_01,
			"CREATED",
			0,
			true
		] call BIS_fnc_taskCreate;
		["t_doc_01", "attack"] call BIS_fnc_taskSetType;
	};
};

// Server only code

if (isServer) then {
	// mission pre init
	inform_unit = objNull;
	civil_units = [
		p_rus_infromator_01,
		p_rus_infromator_02,
		p_rus_infromator_03,
		p_rus_infromator_04,
		p_rus_infromator_05,
		p_rus_infromator_06,
		p_rus_infromator_07,
		p_rus_infromator_08,
		p_rus_infromator_09,
		p_rus_infromator_10,
		p_rus_infromator_11,
		p_rus_infromator_12,
		p_rus_infromator_13
	];
	// try to make civilians not to run away
	east setFriend [civilian, 1];
	civilian setFriend [east, 1];
	independent setFriend [civilian, 1];
	civilian setFriend [independent, 1];
	{ 
		_x setBehaviour "CARELESS";
	} forEach civil_units;
	

	/*
	Select random Informator unit. Disable MOVE and place the trigger
		Arguments: None
		Usage: call Fn_Task_Create_Informator
	*/
	Fn_Task_Create_Informator = {
		//p_rus_infromator_01 setPos ( selectRandom (nearestBuilding p_rus_infromator_01 buildingPos -1));
		private ["_obj"];
		_obj = missionNamespace getVariable [["p_rus_infromator", 9] call BrezBlock_fnc_Get_RND_Index, objNull];
		_obj disableAi "MOVE";
		for "_i" from 1 to 4 do { [_obj] call Fn_Task_Informator_AddTraitor; };
		[] remoteExecCall ["Fn_Local_Task_Create_Informator", [0,-2] select isDedicated];
		inform_action_id = [
			_obj,
			{ _this remoteExec ["Fn_Task_Create_Informator_BlockpostAttack", 2] },
			"simpleTasks\types\talk",
			"ACTION_02",
			"&& alive _target && !task_completed_03"
		] call BrezBlock_fnc_Attach_Hold_Action;
		inform_unit = _obj;
		trgInformDead = createTrigger ["EmptyDetector", getPos _obj];
		trgInformDead setTriggerArea [0, 0, 0, false];
		trgInformDead setTriggerActivation ["NONE", "PRESENT", false];
		trgInformDead setTriggerStatements [
			"{ if (!alive _x) exitWith { true };} forEach civil_units;",
			"if (isServer) then { call Fn_Task_Informator_Failed };",
			""
		];
		p_officer_01 setVariable ["BB_CorpseTTL", -1];
		
		private _trg = createTrigger ["EmptyDetector", getMarkerPos "wp_info_meetup_01"];
		_trg setTriggerArea [250, 250, 0, false];
		_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
		_trg setTriggerStatements [
			"this",
			"execVM 'missions\main.sqf';",
			""
		];
	}; // Fn_Task_Create_Informator

	/*
	Select random Informator unit. Move to east side and give it a gun;
		Arguments: None
		Usage: call Fn_Task_Informator_AddTraitor
	*/
	Fn_Task_Informator_AddTraitor = {
		params ["_informator"];
		private ["_grp", "_units", "_traitor"];
		_units = civil_units - [_informator];
		_traitor = selectRandom _units;
		civil_units = civil_units - [_traitor];
		_grp = createGroup east;
		[_traitor] joinSilent _grp;
		_traitor setBehaviour "SAFE";
		for "_i" from 1 to 2 do {_traitor addItemToUniform "rhs_mag_9x18_12_57N181S";};
		_traitor addWeapon "rhs_weap_makarov_pmm";
	};

	/*
	End mission if any civilian is dead;
		Arguments: None
		Usage: call Fn_Task_Informator_Failed
	*/
	Fn_Task_Informator_Failed = {
		task_completed_03 = false;
		publicVariable "task_completed_03";
		['t_info_meetup', 'Failed', localize 'TASK_08_TITLE'] remoteExecCall ['Fn_Local_SetPersonalTaskState', [0,-2] select isDedicated];
		deleteVehicle trgInformDead;
	}; // Fn_Task_Informator_Failed

	/*
	Start blockpost attack mission;
		Arguments: None
		Usage: call Fn_Task_Create_Informator_BlockpostAttack
	*/
	Fn_Task_Create_Informator_BlockpostAttack = {
		if (!task_completed_03) then {
			task_completed_03 = true;
			publicVariable "task_completed_03";
			['t_info_meetup', 'Succeeded', localize 'TASK_08_TITLE'] remoteExecCall ['Fn_Local_SetPersonalTaskState', [0,-2] select isDedicated];
			[
				p_officer_01,
				"_this remoteExec ['Fn_Task_Informator_DocsFound', 2]",
				"holdactions\holdAction_search",
				"ACTION_01",
				"&& !task_completed_04",
				6,
				true
			] call BrezBlock_fnc_Attach_SearchIntel_Action;
			[] remoteExecCall ["Fn_Local_Task_Create_Informator_BlockpostAttack", [0,-2] select isDedicated];
		};
	}; // Fn_Task_Create_Informator_BlockpostAttack
	
	/*
	If Informator docs were found
	*/
	Fn_Task_Informator_DocsFound = {
		if (!task_completed_04) then {
			task_completed_04 = true;
			publicVariable "task_completed_04";
			['t_doc_01', 'Succeeded', localize 'TASK_20_TITLE'] remoteExecCall ['Fn_Local_SetPersonalTaskState', [0,-2] select isDedicated];
			["outpost_docs_found"] remoteExec ["playSound"];
			["rhs_usa_land_rc_28"] remoteExec ["playSound"];
			if (task_completed_07 && task_completed_06 && task_completed_05 && task_completed_04) then {
				['t_doc_search', 'Succeeded', localize 'TASK_09_TITLE'] remoteExecCall ['Fn_Local_SetPersonalTaskState', [0,-2] select isDedicated];
			};
		};
	};

};
