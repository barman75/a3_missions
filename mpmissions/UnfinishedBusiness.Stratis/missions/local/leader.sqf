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
Spawn start objectives, triggers for informator contact
*/

//Player side triggers
// Client side code
if (hasInterface) then {

	
	Fn_Local_Create_KillLeader = {
		params['_location'];
		private ["_trg"];
		_trg = createTrigger ["EmptyDetector", getMarkerPos format["wp_air_field_%1_01", _location]];
		_trg setTriggerArea [500, 500, 0, false];
		_trg setTriggerActivation ["ANYPLAYER", "PRESENT", true];
		_trg setTriggerStatements [
			"(vehicle player) in thisList",
			getMarkerPos format["[ localize 'INFO_LOC_01', localize 'INFO_SUBLOC_07', format [localize 'INFO_DATE_01', daytime call BIS_fnc_timeToString], mapGridPosition player ] spawn BIS_fnc_infoText;", _location],
			""
		];
		[
			west,
			"t_kill_leader",
			[localize "TASK_08_DESC",
			localize "TASK_08_TITLE",
			localize "TASK_ORIG_01"],
			getMarkerPos format["wp_air_field_%1_01", _location],
			"CREATED",
			0,
			true
		] call BIS_fnc_taskCreate;
		['t_kill_leader', "kill"] call BIS_fnc_taskSetType;
	};
};
