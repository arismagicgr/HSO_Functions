params [
    ["_player", player, [objNull]],
];


// Create Hold Action to Disable BFT
private _id = [
    _player,
    "Disable BFT",
    "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\map_ca.paa",
    "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\map_ca.paa",
    "not (isNil (_target getVariable [""HSO_BFTScriptHandler"", nil]))",
    "true",
    {},
    {},
    {
        [_target] call HSO_fnc_BFTdisable;
    },
    {},
    [],
    0.2,
    0,
    false,
    false,
    false,
    1
] call BIS_fnc_holdActionAdd;

// Store the Hold Action ID in a player variable for future reference
_player setVariable ["HSO_BFTDisableHoldActionID", _id];