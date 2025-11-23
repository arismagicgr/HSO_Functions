if (not isServer) exitWith { "The function is executed only in the Server"; };
params [
  ["_affectedSides", [east, independent], [], [1,2,3,4]], // The sides that will have their pre-placed groups initialised for the QRF system
  ["_delay", ["alertTimeParam",15] call BIS_fnc_getParamValue, [0]], // The time that players will to neutralise the group's units before a QRF is called
  ["_pos", "HSO_QRFspawnPositions", ["", objNull, []], [2,3]], // The position of the spawned group will be spawned
  ["_QRFGroups", "HSO_QRFGroups", [""]], // The unit count of the QRF group
  ["_closestQRF", true, [false]], // If the QRF will spawn from the closest position available
  ["_canCall", ["canCallQRFParam", 1] call BIS_fnc_getParamValue, [1]] // Determines if the QRF group can call another QRF if it identifies a player
];

// Store the params to be used when adding the EH to each group
private _params = [_delay, _pos, _QRFGroups, _closestQRF, _canCall];

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

    // Check if the group is set to be included in the QRF system. Continue to next group if not
    if ( not (_grp getVariable ["includeGrpToQRFSystem", true]) ) exitWith { continue; }; 

    // Check if the group already has the EH added. Continue to next group if it has
    private _EHAdded = _x getVariable ["EnemyDetectedEHID", nil];
    if ( not (isNil _EHAdded) ) exitWith { continue; };


    // Check if there is any player in the group. If there is, do not add
    {
      if (isPlayer _x) exitWith { _addEH = false; };
    } count (units _x);

    // If all the checkes are passed, call the function to add the EH
    if (_addEH) then {
      _params = [_x] + _params; // Add the group to the params array
      _params call HSO_fnc_callQRFEH; // Call the function to add the EH
    };
  } forEach _x;

} forEach _grpPerSide;