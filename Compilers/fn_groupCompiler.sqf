if !(isServer) exitWith { "The function is executed only in the Server"; };
params [
  ["_logic", objNull,[objNull]],
  ["_varName", "HSO_QRFGroups", [""]]
];

// Initialize variables
private _hash = createHashMap;
private _allGrp = [];

// Get the groups of all synchronized objects
{
  _allGrp pushBackUnique (group _x); // pushBackUnique ensures that each group will be "taken" only once
} forEach synchronizedObjects _logic;

// Iterates through all groups, get their units' class names and loadouts, store them together in an array and then the whole array with arrays is stored in the HashMap
// that holds all groups with the grp as key and the data of the group's units as the value
{
  private _grp = _x;
  private _units = [];

  {
    private _className = typeOf _x;
    private _loadout = getUnitLoadout _x;
    private _unitData = [_className, _loadout];
    _units pushBack _unitData;
    // Delete the unit after its data has been retrieved. Cleaning up my mess
    deleteVehicle _x;
  } forEach (units _grp);

  _hash set [str (_grp), _units];

  // Delete the group after the data of all its units has been retrieved and stored. Cleaning up my mess again!
  deleteGroup _grp;

} forEach _allGrp;

// Store the HashMap in a public variable in missionNamespace
missionNamespace setVariable [_varName, _hash, true];
