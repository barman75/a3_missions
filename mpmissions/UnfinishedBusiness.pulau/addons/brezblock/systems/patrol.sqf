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
Create CBA patrol
	Arguments: [_marker]
	Usage: [_marker] call BrezBlock_fnc_CreatePatrol;
	Return: Group
*/
if (isServer) then {
	params['_marker'];
	private['_side'];

	_Fn_BrezBlock_CreateRandomPatrolSquad = {
		params['_side', '_count'];
		private['_units'];
		private _grp = [];
		switch(_side) do
		{
			case west: {
			
			};
			case east: {
			
			};
			case resistance: {
				switch (D_FRACTION_INDEP) do
				{
					case "CUP_I_RACS": { 
						_units = [
							'CUP_I_RACS_Soldier_Light_Mech',
							'CUP_I_RACS_Soldier_Mech',
							'CUP_I_RACS_Medic_Mech',
							'CUP_I_RACS_MMG_Mech'
						];
					};
					case "CUP_I_NAPA": { 
						_units = [
							'CUP_I_GUE_Soldier_AKS74',
							'CUP_I_GUE_Soldier_AKM',
							'CUP_I_GUE_Soldier_AKSU',
							'CUP_I_GUE_Soldier_MG',
							'CUP_I_GUE_Soldier_AR',
							'CUP_I_GUE_Saboteur',
							'CUP_I_GUE_Medic',
							'CUP_I_GUE_Crew'
						];
					};
					case "CUP_I_TK_GUE": { 
						_units = [
							'CUP_I_TK_GUE_Soldier',
							'CUP_I_TK_GUE_Soldier_AK_47S',
							'CUP_I_TK_GUE_Guerilla_Enfield',
							'CUP_I_TK_GUE_Guerilla_Medic',
							'CUP_I_TK_GUE_Soldier_M16A2',
							'CUP_I_TK_GUE_Soldier_AR',
							'CUP_I_TK_GUE_Soldier_MG'
						];
					};
					case "IND_F": {
						_units = [
							'I_soldier_F',
							'I_support_MG_F',
							'I_Soldier_lite_F',
							'I_medic_F'
						];
					};
					case "IND_G_F": {
						_units = [
							'I_G_Soldier_F',
							'I_G_Soldier_lite_F',
							'I_G_medic_F',
							'I_G_Soldier_AR_F',
							'I_G_Soldier_A_F'
						];
					};
				};
			};
			case civilian: {
			
			};
		};
		for "_i" from 1 to _count do
		{
			_grp pushBack (selectRandom _units);
		};
		_grp;
	};
	
	private _radius = getMarkerSize _marker select 0;
	private _center = getMarkerPos _marker;

	private _count = round (_radius / 50) + D_DIFFICLTY;
	
	//https://community.bistudio.com/wiki/Arma_3_CfgMarkerColors
	switch (getMarkerColor _marker) do
	{
		case "ColorWEST": { _side = west; };
		case "ColorEAST": { _side = east; };
		case "ColorGUER": { _side = resistance; };
		case "ColorWEST": { _side = civilian; };
	};
	private _cfg = [_side, _count] call _Fn_BrezBlock_CreateRandomPatrolSquad;
	private _pos = [_center, 5, _radius, 3, 0, 0, 0] call BIS_fnc_findSafePos;
	//http://arma3scriptingtutorials.blogspot.com/2014/02/config-viewer-what-is-it-and-how-to-use.html
	//_grp = [_pos, _side, configfile >> "CfgGroups" >> "Indep" >> D_FRACTION_INDEP >> "Infantry" >> _cfg] call BIS_fnc_spawnGroup;
	private _grp = [_pos, _side, _cfg] call BIS_fnc_spawnGroup;
	
	_grp deleteGroupWhenEmpty true;
	[_grp, _center, _radius, (round (_radius / 15)), "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [5,15,30]] call CBA_fnc_taskPatrol;
	
	_grp;
};