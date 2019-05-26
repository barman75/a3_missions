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

if (hasInterface) then {
	Fn_FastTravel_Sleep = {
		if (alive player) then {
			playSound "radio_chatter_00";
			playSound "rhs_usa_land_rc_2";
			[0, 5] execVM "addons\brezblock\utils\fade.sqf";
		};
	};
	
	Fn_FastTravel_Wokeup = {
		if (alive player) then {
			playSound "radio_chatter_01";
			playSound "rhs_usa_land_rc_5";
			[1, 5] execVM "addons\brezblock\utils\fade.sqf";
		};
	};
};

if (isServer) then {
	private['_markerPos', "_wp"];
	sleep 20;
	{
		remoteExecCall ["Fn_FastTravel_Sleep", _x];
	} forEach assault_group;
	_markerPos = getMarkerPos 'wp_waypoint_01';
	us_airplane_01 setPos [(_markerPos select 0), (_markerPos select 1), ((_markerPos select 2) + 1500)];
	us_airplane_01 setDir (markerDir 'wp_waypoint_01');
	us_airplane_01 flyInHeight 1200;
	_group = group driver us_airplane_01;
	deleteWaypoint [_group, 0]; 
	_wp = _group addWaypoint [getMarkerPos 'wp_air_field_01', 0];
	_wp setWaypointCombatMode "YELLOW";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointSpeed "LIMITED";
	_w setWaypointFormation "NO CHANGE";
	_wp setWaypointType "MOVE";
	(driver us_airplane_01) setBehaviour "Careless";
	sleep 15;
	{
		remoteExecCall ["Fn_FastTravel_Wokeup", _x];
	} forEach assault_group;
};