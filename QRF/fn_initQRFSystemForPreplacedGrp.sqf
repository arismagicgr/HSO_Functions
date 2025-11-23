if (not isServer) exitWith { "The function is executed only in the Server"; };
params [
  ["_affectedSides", [east, independent], [], [1,2,3,4]]
];

// Get all pre-placed groups in the mission and add them in array per side
private _grpPerSide = []; // Initialize array that will store arrays of groups per side
private _sideGrp = []; // Initialize array that will store groups of a side

// For each affected side, get all groups of that side and store them in the array
{
  private _side = _x; // Get the side
  _sideGrp = allGroups select { (side _x) isEqualTo _side; }; // Get all groups of that side
  _grpPerSide pushBackUnique _sideGrp; // Add the array of groups to the main array
} forEach _affectedSides; 



// For each group, add the event handler that will handle the QRF logic when the group is created
{

  // For each group in the side's array, check if it should be initialised for the QRF system
  {
    private _addEH = true; // Initialize variable to determine if EH should be added
    private _grp = _x // Get the group

    // Check if there is any player in the group. If there is, do not add
    {
      if (isPlayer _x) exitWith { _addEH = false; };
    } count (units _grp)

    // If all the checkes are passed, call the function to add the EH
    if (_addEH) then { [_x] call HSO_fnc_callQRFEH; };
  } forEach _x;

} forEach _grpPerSide;