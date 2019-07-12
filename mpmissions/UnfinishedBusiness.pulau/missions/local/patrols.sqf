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

	vehicle_confiscate_group = [];

	Fn_Local_Patrols_ConfiscateVehicle = {
		params ["_target", "_caller", "_actionId", "_arguments"];
		private["_driver"];
		if (alive _target) then {
			_driver = driver _target;
			if (!isNull _driver) then {
				if ((!isPlayer _driver) && (alive _driver)) then {
					doGetOut _driver;
				};
			};
		};
	};
	
	while {count vehicle_confiscate_group == 0} do {
		sleep 10;
	};
		
	{
		_x addAction [localize 'ACTION_03', "call Fn_Local_Patrols_ConfiscateVehicle;", nil, 1, false, true, "", "alive _this", 10];
	} forEach vehicle_confiscate_group;
};