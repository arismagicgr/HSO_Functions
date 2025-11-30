params [
    ["_player", player, [objNull]],
    ["_includePlayer", false, [false]],
    ["_interval", 300, [0]]
];

if ( not (local _player) ) exitWith { diag_log "The HSO_fnc_BFTinit is executed only where the ""player"" is local"; };

_this call HSO_fnc_BFTenableHoldAction;
[_player] call HSO_fnc_BFTdisableHoldAction;