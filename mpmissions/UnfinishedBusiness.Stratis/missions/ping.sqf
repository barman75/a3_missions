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
	If assault group is dead -- end game;
	Usage: execVM ["missions/assault_group_is_dead.sqf"];
	Return: true
*/

if (isServer) then {
	while {count assault_group != 0} do {
		sleep 30;
		//[[independent, "HQ"], "ping..."] remoteExec ["sideChat"];
		//[[east, "HQ"], "ping..."] remoteExec ["sideChat"];
		//[[west, "HQ"], "WEST ping..."] remoteExec ["sideChat"];
		if (count pings > 0) then {
			{
				[[independent, "HQ"], format ["Enemy %1 spotted. Grid: %2", _forEachIndex, _x]] remoteExec ["sideChat"];
				[[east, "HQ"], format ["Enemy %1 spotted. Grid: %2", _forEachIndex, _x]] remoteExec ["sideChat"];
				//[[west, "HQ"], format ["WEST Enemy spotted. Grid: %1", _x]] remoteExec ["sideChat"];
			} forEach pings;
			pings = [];
		};
	};
};