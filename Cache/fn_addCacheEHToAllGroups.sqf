if (!isServer) exitWith {diag_log "LNO Cache: The function that adds the appropriate EH to all groups runs only on Server";};

// Loop through all groups and add the appropriate EH to the groups that do not have one
{
  // Check if the group exists and it already has an EH
  private _isNull = isNull _x; // The group exists
  private _isNil = isNil {_x getVariable ["LNO_cacheEHID", nil]}; // The group does not has an EN already

  //If non is true execute the command to add the appropriate EH to the group and store its ID for deletion later by LNO_fnc_disableCache
  if (!_isNull AND _isNil) then {
      private _id = [_x] call LNO_fnc_addCacheEH;
      _x setVariable ["LNO_cacheEHID", _id, true];
    } else {
      // Else, log a message
      diag_log (format ["LNO Cache: %1 does not exists or it already has an EH", _x])
    };

} forEach allGroups;

true;
