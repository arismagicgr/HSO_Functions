if (not isServer) exitWith { diag_log "The HSO_fnc_terminateQRFSystem function is executed only in the Server"; };

params [
    ["_affectedSides", [west, east, independent, civilian], [], [1,2,3,4]]
];
/*==================================== REMOVE GROUP CREATED EH ====================================*/

// Get all existing EH IDs stored in missionNamespace
private _EHIDs = missionNamespace getVariable ["HSO_QRFGroupCreatedEHID", nil];

if ( not (isNil "_EHIDs") ) then {
    // Loop through all EH IDs and remove them
    {
        removeMissionEventHandler _x;
    } forEach _EHIDs;

    // Clear the EH IDs stored in missionNamespace
    missionNamespace setVariable ["HSO_QRFGroupCreatedEHID", nil, true];
};


/*==================================== REMOVE ENEMY DETECTED EH FROM ALL GROUPS ====================================*/
private _allGrp = allGroups select { (side _x) in _affectedSides; }; // Get all groups of the affected sides

// Loop through all groups and remove the "Enemy Detected" EH if it exists
{
    [_x] call HSO_fnc_removeGrpFromQRFSystem;
} forEach _allGrp;
