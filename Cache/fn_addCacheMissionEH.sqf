// Execute only on the server
if (!isServer) exitWith { "The mission EH of the Cache System is added only from the Server" };

// Check if there is already a missionEH has been added
private _alreadyExists = !isNil { missionNamespace getVariable ["LNO_cacheMissionEHID", nil] };

// If it already exists, exit the function
if (_alreadyExists) exitWith {diag_log "LNO Cache: Cache Mission EH already exists. No EH was added"; };

// Add the mission EH and get the ID for deletion by the LNO_fnc_disableCache
private _missionEHID = addMissionEventHandler ["GroupCreated", {
  params ["_grp"];

  // Check if the group already has an EH or does not exist (isNull) and exit if at least one is true
  private _isNil = isNil {_grp getVariable ["LNO_cacheEHID", nil]};
  if (isNull _grp OR !_isNil) exitWith { diag_log (format ["Group %1 is not defined or it already has an EH", _grp]); };
  // Run the function to add the appropriate EH to the group ("CombatModeChanged") and get the EH ID
  private _id = [_grp] call LNO_fnc_addCacheEH;
  // Store the EH ID in group's namespace to be available for deletion later by the LNO_fnc_disableCache
  _grp setVariable ["LNO_cacheEHID", _id, true];
}];

// Store the mission EH ID for deletion later by the LNO_fnc_disableCache
missionNamespace setVariable ["LNO_cacheMissionEHID", [_missionEHID, "GroupCreated"], true];

// Return an array with mission EH ID and EH type in case someone wants to use it somehow!
[_missionEHID, "GroupCreated"];
