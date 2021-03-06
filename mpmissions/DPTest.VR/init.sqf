/***************************************************************************************
 * Copyright (C) 2008-2020 by Oleksii S. Malakhov <brezerk@gmail.com>                  *
 *                                                                                     *
 * This program is is licensed under a                                                 *
 * Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. *
 *                                                                                     *
 * You should have received a copy of the license along with this                      *
 * work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.              *
 *                                                                                     *
 **************************************************************************************/

#include "config\realm.sqf";

if (!isServer) exitWith {};

civilian setFriend [resistance, 0];

0 = [] spawn NECK_fnc_PersistanceLoad;

{
	//Enable arsenal
	0 = ["AmmoboxInit", [_x, true] ] spawn BIS_fnc_arsenal;
} count D_PERSISTANCE_OBJECTS;

0 = [] spawn NECK_fnc_PersistanceSave;
