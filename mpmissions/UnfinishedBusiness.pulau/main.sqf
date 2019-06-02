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

if (isServer) then {
	_westHQ = createCenter west;
	_eastHQ = createCenter east;
	_indepHQ = createCenter independent;
	D_FRACTION_INDEP = "CUP_I_NAPA"; //posible CUP_I_TK_GUE, IND_F, IND_F, IND_G_F
	_civilianHQ = createCenter civilian;

	assault_group = [];

	//#include "missions\intro.sqf";
	//#include "missions\patrols.sqf";
	//#include "missions\aa.sqf";
	//#include "missions\leader.sqf";
	//#include "missions\civilian\cargo.sqf";

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
	
	//sleep 5;
	
	//call Fn_Create_MissionIntro;
	//[getMarkerPos "wp_cargo_03"] call Fn_Task_Create_Civilian_FloodedShip;
	
	//{
	//	[_x] joinSilent createGroup [independent, true];
	//} forEach [synd_police_01, synd_police_02, synd_police_03];
	
	/*["wp_civ_test"] call BrezBlock_fnc_CreateCivilianPresence;
	{
		[_x] call BrezBlock_fnc_CreatePatrol;
	} forEach ["wp_indep_test", "wp_indep_test_1", "wp_indep_test_2"];*/
	
	//_markers = allMapMarkers select {(getMarkerPos _x) inArea yourTrigger}
	/*{
		if (_x find "wp_" >= 0) then {
		//if (markerType  _x != "") then {
			systemChat format ["WOOT? %1 %2", markerBrush _x, markerType _x];
		//};
		};
	} forEach allMapMarkers;*/
	
	
	Fn_Process_Marker = {
		params['_marker'];
		private['_grp'];
		switch(markerBrush _x) do
		{
			case "Solid": {_grp = [_x] call BrezBlock_fnc_CreateCivilianPresence; format ["Spawn CIV why? %1 %2", _x, markerBrush _x];};
			case "SolidBorder": {_grp = [_x] call BrezBlock_fnc_CreatePatrol;};
			case "DiagGrid": {_grp = [_x] call BrezBlock_fnc_CreatePatrol;};
		};
		_grp;
	};
	
	Fn_Spawn = {
		params['_trigger'];
		private['_grp'];
		{
			if (getMarkerPos _x inArea _trigger) then {
				if (markerType _x in ["ellipse", "square"]) then {
					_grp = [_x] call Fn_Process_Marker;
					_trigger setVariable [_x, _grp, false];
				};
			};
		} forEach allMapMarkers; //select {(getMarkerPos _x) };
	};
	
	Fn_Despawn = {
		params['_trigger'];
		private['_grp', '_count'];
		_count = 0;
		{
			if (getMarkerPos _x inArea _trigger) then {
				if (markerType _x in ["ellipse", "square"]) then {
					_count = _count + 1;
					_grp = _trigger getVariable [_x, grpNull];
					if (!(isNull _grp)) then {
						if ({ alive _x } count units _grp == 0) then {
							deleteMarker _x;
							_count = _count - 1;
						} else {
							{deletevehicle _x} foreach units _grp;
							_trigger setVariable [_x, grpNull, false];
						};
					} else {
						systemChat "WARNING: Looks like group was killed\lost?";
					};
				};
			};
		} forEach allMapMarkers;
		if (_count == 0) then {
			systemChat "Ok. No markers left. Removing trigger.";
			deleteVehicle _trigger;
		};
	};
	
	{
		systemChat "Got trigger!";
		_x setTriggerActivation ["ANYPLAYER", "PRESENT", true];
		_x setTriggerStatements [
				"this",
				"[thisTrigger] call Fn_Spawn;",
				"[thisTrigger] call Fn_Despawn;"
		];
	} forEach allMissionObjects "EmptyDetector";
};

// We need to end game if all players are no longer alive
//[] execVM "addons\brezblock\triggers\end_game.sqf";
