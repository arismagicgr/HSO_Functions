params [
  ["_group", [grpNull], [grpNull]]
];

// Add an EH of type "CombatModeChanged" to call the function that manages the caching state of the group when it gets into combat "COMBAT"
_group addEventHandler ["CombatModeChanged", {
	params ["_grp", "_newMode"];

  // If the group gets into combat, decache the group immediatelly and exit the script
  if {_newMode isEqualTo "COMBAT"} exitWith {
    [_grp] call LNO_fnc_decacheGroup;
  };
}];
