params [
    ["_player", player, [objNull]],
    ["_includePlayer", false, [false]],
    ["_interval", 300, [0]]
];

// Ensure the script runs only where the player is local
if ( not (local _player) ) exitWith { diag_log "The HSO_fnc_BFTenable is executed only where the ""player"" is local"; };

// Prevent multiple instances of the script for the same player
if ( not (isNil (_player getVariable ["HSO_BFTScriptHandler", nil]))) exitWith { diag_log "The HSO_fnc_BFTenable is already running for this player"; };

// Store the script handler in a player variable for potential future use
_player setVariable ["HSO_BFTScriptHandler", _thisScript];

// Main loop to continuously update markers
while { true } do {

    // Determine side and color
    private _side = side _player; // get the side of the player

    // Define color based on side
    private _color = switch (_side) do {
        case west: { "colorBLUFOR" };
        case east: { "colorOPFOR" };
        case independent: { "colorIndependent" };
        case civilian: { "colorCivilian" };
    };

    // Get all groups of the same side as the player
    private _grp = allGroups select { (side _x) isEqualTo _side; };

    // Exclude player's own group if not including player
    if (not _includePlayer) then {
        _grp deleteAt (_grp find (group _player));
    };

    // Retrieve existing markers from player variable
    private _arr = _player getVariable ["HSO_BFTMarkers", []];
    
    
    // Delete existing markers if any
    if ((count _arr) > 0) then {
        {deleteMarkerLocal _x;} forEach _arr;
        _arr = []; // reset the array to store new markers
    };

    private ["_leader", "_veh", "_marker", "_markerType", "_rank", "_count"];

    {
        // Create the type marker for each group and the text with its leader's name and rank
        _leader = leader _x; // Get the leader of the group
        _veh = objectParent _leader; // Get the vehicle of the leader

        _marker = createMarkerLocal [format ["%1", groupId _x], position _leader]; // Create a local type marker at the leader's position
        _marker setMarkerColorLocal _color;
        
        // Determine marker type based on vehicle
        _markerType = switch (true) do {
                    case (isNull _veh): { "_inf"; };
                    case ("APC" in (typeOf _veh)): { "_mech_inf"; };
                    case (_veh isKindOf "Helicopter"): { "_air"; };
                    case (_veh isKindOf "Plane"): { "_plane"; };
                    case (_veh isKindOf "Ship"): { "_naval"; };
                };

        // Prefix marker type with side identifier
        _markerType = switch (_side) do {
            case (west): { format ["b%1", _markerType]; };
            case (east): { format ["o%1", _markerType]; };
            case (independent): { format ["n%1", _markerType]; };
            case (civilian): { "hd_dot"; };
        };


        _rank = rank _leader; // Get the rank of the leader
        // Determine leader's rank abbreviation
        _rank = switch (true) do {
            case (_rank isEqualTo "PRIVATE"): { "Pvt." };
            case (_rank isEqualTo "CORPORAL"): { "Cpl." };
            case (_rank isEqualTo "SERGEANT"): { "Sgt." };
            case (_rank isEqualTo "LIEUTENANT"): { "Lt." };
            case (_rank isEqualTo "CAPTAIN"): { "Cpt." };
            case (_rank isEqualTo "MAJOR"): { "Maj." };
            case (_rank isEqualTo "COLONEL"): { "Col." };
            case (_rank isEqualTo "GENERAL"): { "Gen." };
        };
        
        _marker setMarkerTypeLocal _markerType; // Set the marker type
        _marker setMarkerTextLocal (format ["%1 | Leader: %2 %3", groupId _x, _rank, name _leader]); // Set the marker text
        _arr pushBack _marker; // Store the marker in the array

        // Create the Unit Size Indicator marker for each group
        private _count = count (units _x);
        switch (true) do {
            case ((_count > 0) AND (_count < 5)): { _markerType = "group_0"; };
            case (_count < 10): { _markerType = "group_1"; };
            case (_count < 20): { _markerType = "group_2"; };
            case (_count < 30): { _markerType = "group_3";};
            case (_count < 180): { _markerType = "group_4"; };
            default { _markerType = ""; };
        };

        _marker = createMarkerLocal [format ["%1_size", groupId _x], position _leader]; // Create a local marker at the leader's position
        _marker setMarkerTypeLocal _markerType; // Set the marker type
        _arr pushBack _marker; // Store the marker in the array

    } forEach _grp;

    // Store the new markers in the player variable
    _player setVariable ["HSO_BFTMarkers", _arr];

    sleep _interval; // Wait for the specified interval before updating again
};