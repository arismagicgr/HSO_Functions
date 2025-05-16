if (!isServer) exitWith {};

params [
  ["_tick", ["HSO_cacheSystemBatchIteration", 1] call BIS_fnc_getParamValue, [0]],
  ["_batchSize", ["HSO_cacheSystemBatchSize",10] call BIS_fnc_getParamValue, [0]]
];

private _params = [_tick, _batchSize];

private _run = missionNamespace getVariable ["HSO_cacheSystemRunning", false];

if !(_run) then {
  _params spawn HSO_fnc_batchProcessor;
} else {
  diag_log "HSO Cache System already running. Skipping initialization.";
};



// Check if the loop that adds the EH ("CombatModeChanged") to all active/existing groups has run and if not, then
// it runs it again and flags it as "true" to avoid duplicates.
// The "flag" is set to false by the disabling function after it deletes the EH from all existing groups
if !(missionNamespace getVariable ["HSO_cacheEHAddedToAllGroups", false]) then {

  // Loop and add the EH ("CombatModeChanged") to all existing groups
  {
    // Execute the function that adds the EH and gets the ID to delete the EH if needed by the disabling function
    private _id = [_x] call HSO_fnc_addCacheEH;

    // Store the EH's ID to a variable in group's namespace to be retrievable by the disabling function to delete the EH
    _x setVariable ["HSO_cacheEHID", _id, true];

  } forEach allGroups;

  // Set the "flag" as true to avoid duplicate actions in case the init function runs again.
  // The flag is turned to false again by the disabling function after it deletes the EH from allGroups
  missionNamespace setVariable ["HSO_cacheEHAddedToAllGroups", true, true];
};


// Check if the mission EH that will add the appropriate EH ("CombatModeChanged") to newly created groups
// And if it has not been added, add one
if !(missionNamespace getVariable ["HSO_cacheMissionEHAdded", false]) then {

  // Add the EH and get the ID in case needs to be deleted (by disabling caching system function)
  private _id = addMissionEventHandler ["GroupCreated", {
    params ["_grp"];

    // Execute the function that adds the EH and gets the ID to delete the EH if needed by the disabling function
    private _id = [_grp] call HSO_fnc_addCacheEH;

    // Store the EH's ID to a variable in group's namespace to be retrievable by the disabling function to delete the EH
    _x setVariable ["HSO_cacheEHID", _id, true];
    }];

    // Store the ID of the EH in a global variable to be available to the disabling function to delete the EH
    missionNamespace setVariable ["HSO_cacheMissionEHID", _id, true];

    // Set the "flag" as true to avoid duplicate actions
    missionNamespace setVariable ["HSO_cacheMissionEHAdded", true, true];
  };

// Returns true to know that the function was executed properly
true;
