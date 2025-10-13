if (!isServer) exitWith { "The function is executed only in the Server"; };
{
  private _addEH = true;
  private _grp = _x
  {
    if (isPlayer _x) exitWith { _addEH = false };
    sleep 0.1;
  } count (units _grp)
  if (_addEH) then { [_x] call HSO_fnc_callQRFEH; };
  sleep 0.1;
} forEach allGroups;
