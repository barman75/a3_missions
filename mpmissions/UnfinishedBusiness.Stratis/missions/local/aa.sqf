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

	private ["_trg"];
	_trg = createTrigger ["EmptyDetector", getMarkerPos "wp_aa"];
	_trg setTriggerArea [180, 180, 0, false];
	_trg setTriggerActivation ["ANYPLAYER", "PRESENT", true];
	_trg setTriggerStatements [
		"(vehicle player) in thisList",
		"[ localize 'INFO_LOC_01', localize 'INFO_SUBLOC_06', format [localize 'INFO_DATE_01', daytime call BIS_fnc_timeToString], mapGridPosition player ] spawn BIS_fnc_infoText;",
		""
	];

	Fn_Local_Create_MissionAA = {
		[
			west,
			"t_destroy_aa",
			[localize "TASK_06_DESC",
			localize "TASK_06_TITLE",
			localize "TASK_ORIG_01"],
			getMarkerPos "wp_aa",
			"CREATED",
			0,
			true
		] call BIS_fnc_taskCreate;
		['t_destroy_aa', "destroy"] call BIS_fnc_taskSetType;
		[
			west,
			"t_destroy_comtower",
			[localize "TASK_07_DESC",
			localize "TASK_07_TITLE",
			localize "TASK_ORIG_01"],
			getMarkerPos "wp_aa",
			"CREATED",
			0,
			true
		] call BIS_fnc_taskCreate;
		['t_destroy_comtower', "destroy"] call BIS_fnc_taskSetType;
	};
};
