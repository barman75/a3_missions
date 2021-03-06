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
Spawn start objectives, triggers and mainline story
*/

// Client side code
if (hasInterface) then {
	Fn_Local_Task_Create_Spotter = {
		[
			player,
			"t_recon_kill",
			[localize "TASK_21_DESC",
			localize "TASK_21_TITLE",
			localize "TASK_ORIG_02"],
			objNull,
			"CREATED",
			0,
			true
		] call BIS_fnc_taskCreate;
		["t_recon_kill", "attack"] call BIS_fnc_taskSetType;
	};
	
	Fn_Local_Task_Spotter_DocsFound = {
		[
			player,
			["t_doc_04", "t_doc_search"],
			[localize "TASK_13_DESC",
			localize "TASK_13_TITLE",
			localize "TASK_ORIG_01"],
			objNull,
			"SUCCEEDED",
			0,
			true
		] call BIS_fnc_taskCreate;
		['t_doc_04', "documents"] call BIS_fnc_taskSetType;
		playSound "outpost_docs_found";
		playSound "rhs_usa_land_rc_28";
	};
};

if (isServer) then {
	Fn_Task_Create_Spotter = {
		private ["_type"];
		marker = ["wp_recon", 8] call BrezBlock_fnc_Get_RND_Index;
		{
			_type = typeName _x;
			if (_type == "GROUP") then {
				_x setBehaviour "STEALTH";
				_x setCombatMode "BLUE";
				_x setSpeedMode "LIMITED";
				_units = units _x;
				{
					_x setDir (markerDir marker);
					_x disableAi "MOVE";
				} forEach _units;
			};
		} forEach ([marker, "rus_p_spotter_01"] call BrezBlock_fnc_Spawn_Objective);
		[] remoteExecCall ["Fn_Local_Task_Create_Spotter", [0,-2] select isDedicated];
		trgSpotterKilled = createTrigger ["EmptyDetector", getPos player];
		trgSpotterKilled setTriggerArea[0,0,0,false];
		trgSpotterKilled setTriggerActivation ["NONE", "PRESENT", false];
		trgSpotterKilled setTriggerStatements ["!alive p_rus_spotter_01", "['t_recon_kill', 'Succeeded', localize 'TASK_21_TITLE'] remoteExecCall ['Fn_Local_SetPersonalTaskState', [0,-2] select isDedicated]; deleteVehicle trgSpotterKilled;", ""];
		[
			p_rus_spotter_01,
			"_this remoteExec ['Fn_Task_Spotter_DocsFound', 2]",
			"holdactions\holdAction_search",
			"ACTION_01",
			"&& !task_completed_07",
			6,
			true
		] call BrezBlock_fnc_Attach_SearchIntel_Action;
	};
	
	/*
	If Spotter docs were found;
	*/
	Fn_Task_Spotter_DocsFound = {
		if (!task_completed_07) then {
			task_completed_07 = true;
			publicVariable "task_completed_07";
			[] remoteExecCall ["Fn_Local_Task_Spotter_DocsFound", [0,-2] select isDedicated];
			if (task_completed_07 && task_completed_06 && task_completed_05 && task_completed_04) then {
				['t_doc_search', 'Succeeded', localize 'TASK_09_TITLE'] remoteExecCall ['Fn_Local_SetPersonalTaskState', [0,-2] select isDedicated];
			};
		};
	};
};
