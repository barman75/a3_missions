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

sleep 3;
us_airplane_01 animateDoor ['Door_1_source', 1];
sleep 3;
private _expl1 = "DemoCharge_Remote_Ammo_Scripted" createVehicle (position us_airplane_01);
_expl1 attachTo [us_airplane_01, [0.0,0.0,0.0]];
_expl1 setDamage 1;
sleep 3;
if (alive us_airplane_01) then {
	us_airplane_01 setHitPointDamage ["hitEngine", 1.0];
};