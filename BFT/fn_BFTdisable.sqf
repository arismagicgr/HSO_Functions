params [
    ["_player", player, [objNull]]
];

// Get the script handler for this player
private _script = _player getVariable ["HSO_BFTScriptHandler", nil];

// If no script handler found, exit
if ( isNil _script ) exitWith { diag_Log "No BFT script handler found for this player, exiting BFT disable script."; };

// If script handler is found, terminate the script
terminate _script;

// Clear the script handler variable
_player setVariable ["HSO_BFTScriptHandler", nil];

// Get all existing markers for this player
private _markers = _player getVariable ["HSO_BFTMarkers", []];

// Delete all existing markers if any
if (count _markers > 0) then {
    {deleteMarkerLocal _x;} forEach _markers;
    _player setVariable ["HSO_BFTMarkers", []];
};

// Return success
true;