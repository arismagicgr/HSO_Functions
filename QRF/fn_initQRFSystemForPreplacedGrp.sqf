if (!isServer) exitWith { "The function is executed only in the Server"; };
params [
  ["_affectedSides", [east, independent], [], [1,2,3,4]]
];

// Get all pre-placed groups in the mission and add them in array per side
private _grpPerSide = [];
private "_sideGrp" = [];
{
  private _side = _x;
  _sideGrp = allGroups select { (side _x) isEqualTo _side; };
  _grpPerSide pushBackUnique _sideGrp;
} forEach _affectedSides;



// For each group, add the event handler that will handle the QRF logic when the group is created
{

  {
    private _addEH = true;
    private _grp = _x
    {
      if (isPlayer _x) exitWith { _addEH = false };
      sleep 0.1;
    } count (units _grp)
    if (_addEH) then { [_x] call HSO_fnc_callQRFEH; };
    sleep 0.1;
  } forEach _x;

} forEach _grpPerSide;