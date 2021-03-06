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
Populate base items for supply box
*/

params['_obj', '_type', '_side', '_faction'];
clearWeaponCargoGlobal _obj;
clearMagazineCargoGlobal _obj;
clearItemCargoGlobal _obj;
clearBackpackCargoGlobal _obj;

{
	private _class = (_x select 0);
	private _count = (_x select 1);
	private _type = _class call BIS_fnc_itemType;
		switch (_type select 0) do {
			case 'Weapon': { 
				_obj addWeaponCargoGlobal [_class, _count];
			};
			case 'Magazine': {
				_obj addMagazineCargoGlobal [_class, _count];
			};
			case 'Item': { _obj addItemCargoGlobal [_class, _count]; };
			case 'Mine': { _obj addItemCargoGlobal [_class, _count]; };
			case 'Equipment': { 
				if ((_type select 1) == "Backpack") then {
					_obj addBackpackCargoGlobal [_class, _count];	
				} else {
					_obj addItemCargoGlobal [_class, _count];									
				};
			};
			default { systemChat format ["Error: can't get item type: %1", _class]; };
		};	
} forEach ([_side, _faction, (format ["stash_%1_items", _type])] call Fn_Config_GetFraction_Units);
		
if (D_MOD_ACE) then {
	_obj addWeaponCargoGlobal ["ACE_VMH3", 2];
	_obj addItemCargoGlobal ["ACE_EntrenchingTool", 4];
	_obj addItemCargoGlobal ["ACE_EarPlugs", 10];
	_obj addItemCargoGlobal ["ACE_DefusalKit", 5];
	_obj addItemCargoGlobal ["ACE_Clacker", 5];
} else {
	_obj addItemCargoGlobal ["MineDetector", 5];
};

private _multiplier = 1;

if (_type == "base") then {
	_multiplier = 10;
};

if (D_MOD_ACEX) then {
	_obj addItemCargoGlobal ["ACE_Humanitarian_Ration", (10 * _multiplier)] ;
	_obj addItemCargoGlobal ["ACE_WaterBottle", (10 * _multiplier) ];
};
		
if (D_MOD_ACE_MEDICAL) then {
	_obj addItemCargoGlobal ["ACE_fieldDressing", (25 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_morphine", (15 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_adenosine", (10 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_personalAidKit", (10 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_splint", (10 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_epinephrine", (5 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_bloodIV", (10 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_tourniquet", (5 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_surgicalKit", (5 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_packingBandage", (15 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_elasticBandage", (15 * _multiplier)];
	_obj addItemCargoGlobal ["ACE_quikclot", (15 * _multiplier)];
} else {
	_obj addItemCargoGlobal ["FirstAidKit", (25 * _multiplier)];
};
		
_obj addItemCargoGlobal ["ClaymoreDirectionalMine_Remote_Mag", 6];
_obj addItemCargoGlobal ["DemoCharge_Remote_Mag", 4];
			
if (D_MOD_ACRE) then {
		_obj addItemCargoGlobal ["ACRE_PRC152", 4];
		_obj addItemCargoGlobal ["ACRE_PRC343", 10];
} else {
	if (D_MOD_TFAR) then {
		switch (_side) do {
			case west: {
				_obj addItemCargoGlobal ["tf_anprc152", 10];
				_obj addBackpackCargoGlobal ["tf_rt1523g_fabric", 4];
			};
			case east: { 
				_obj addItemCargoGlobal ["tf_fadak", 10];
				_obj addBackpackCargoGlobal ["tf_mr3000", 4];
			};
			case independent: {
				_obj addItemCargoGlobal ["tf_anprc148jem", 10];
				_obj addBackpackCargoGlobal ["tf_anprc155", 4];
			};
			case civilian: {
				_obj addItemCargoGlobal ["tf_anprc148jem", 10];
				_obj addBackpackCargoGlobal ["tf_anprc155", 4];
			};
		};
	} else {
		_obj addItemCargoGlobal ["ItemRadio", 10];
	};
};
