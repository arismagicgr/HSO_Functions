params [
    ["_grp", grpNull, [grpNull]] // The group to remove the EH from
];

private _id = _grp getVariable ["HSO_QRFEnemyDetectedEHID", nil]; // Get the EH ID stored in the group
if ( not (isNil "_id")) then {
    _grp removeEventHandler _id; // Remove the EH from the group
    _grp setVariable ["HSO_QRFEnemyDetectedEHID", nil, true]; // Clear the EH ID stored in the group
};