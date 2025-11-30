params [
    ["_player", player, [objNull]],
    ["_includePlayer", false, [false]],
    ["_interval", 300, [0]]
];


// Create Hold Action to Enable BFT
private _id = [
    _player,
    "Enable BFT",
    "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\map_ca.paa",
    "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\map_ca.paa",
    "isNil (_target getVariable [""HSO_BFTScriptHandler"", nil])",
    "true",
    {},
    {},
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _arguments params ["_includePlayer", "_interval"];
        [_target, _includePlayer, _interval] spawn HSO_fnc_BFTenable;
    },
    {},
    [_includePlayer, _interval],
    0.2,
    0,
    false,
    false,
    false,
    1
] call BIS_fnc_holdActionAdd;

// Store the Hold Action ID in a player variable for future reference
_player setVariable ["HSO_BFTEnableHoldActionID", _id];