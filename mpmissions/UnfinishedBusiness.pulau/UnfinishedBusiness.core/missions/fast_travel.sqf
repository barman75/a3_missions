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
	sleep 10;
	{
		remoteExecCall ["Fn_Local_FastTravel_Sleep", _x];
	} forEach assault_group;
	sleep 8;
	//skipTime 1;
	private _markerPos = getMarkerPos "mrk_flight_waypoint";
	private _vel = velocity us_airplane_01;
	us_airplane_01 setPosASL [(_markerPos select 0), (_markerPos select 1), ((_markerPos select 2) + 1500)];
	us_airplane_01 setDir (markerDir "mrk_flight_waypoint");
	us_airplane_01 setVelocity _vel;
	private _group = (group (driver us_airplane_01));
	private _wp = _group addWaypoint [getMarkerPos "mrk_airfield", 0, 0];
	_wp setWaypointCombatMode "YELLOW";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointSpeed "FULL";
	_wp setWaypointFormation "NO CHANGE";
	_wp setWaypointType "MOVE";
	us_airplane_01 flyInHeight 1500;
	(driver us_airplane_01) setBehaviour "Careless";
	{
		remoteExecCall ["Fn_Local_FastTravel_Wokeup", _x];
	} forEach assault_group;
};