if (not isServer) exitWith { diag_log "The HSO_fnc_terminateQRFSystem function is executed only in the Server"; };

params [
    ["_affectedSides", [west, east, independent, civilian], [], [1,2,3,4]]
];
/*==================================== REMOVE GROUP CREATED EH ====================================*/

private _EHData = missionNamespace getVariable ["HSO_QRFGroupCreatedEHID", nil]; // Get the EH data stored in missionNamespace
removeMissionEventHandler _EHData; // Remove the EH
missionNamespace setVariable ["HSO_QRFGroupCreatedEHID", nil, true]; // Clear the EH data stored in missionNamespace

/*==================================== REMOVE ENEMY DETECTED EH FROM ALL GROUPS ====================================*/
private _allGrp = allGroups select { (side _x) in _affectedSides; }; // Get all groups of the affected sides

{
    private _id = _x getVariable ["EnemyDetectedEHID", nil];
    if ( not (isNil "_id")) then {
        _x removeEventHandler _id;
        _x setVariable ["EnemyDetectedEHID", nil, true];
    };
} forEach _allGrp;
