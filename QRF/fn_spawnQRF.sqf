params [
  ["_grp", grpNull, [grpNull]], // The group that "called" the QRF
  ["_pos", "HSO_QRFspawnPositions", [""]], // Variable name in missionNamespace that holds the objects that act as possible enemy spawn positions
  ["_QRFGroups", "HSO_QRFGroups", [""]], // Variable Name that holds the HashMap of all the groups that can be used as QRF
  ["_closestQRF", false, [false]], // If the QRF will spawn to the closes possible position
  ["_canCall", ["canCallQRF", 1] call BIS_fnc_getParamValue, [1]]
];

// Get the leader of the group to do the calculations and get the position for the waypoint
private _leader = leader _grp;


//////////////////////////// SPAWN POSITION ///////////////////////////////////////
// Find the (closest) QRF spawn position
_pos = missionNamespace [_pos, []];

if ((count _pos) isEqualTo 0) exitWith {

  private _text = ["[FROM ENEMY RADIO]","<t color='#E60000'>[ENEMY HQ] Negative, is not possible to send QRF...</t>"];
  // If there is not a position available to spawn the group, inform the players near the leader of the group and exit the script
  _text remoteExec ["BIS_fnc_showSubtitle", (allPlayers distance (leader _grp)) <= 50, false];

};

// Find the QRF Spawn Position closest to the leader of the group that called QRF. If _closestQRF is set to true, then this will be used as spawn position
if (_closestQRF) then {
  // Pick the first position and its distance from leader of the group that called the QRF
  _closestDistance = _leader distanceSqr (_pos select 0);
  _spawnPos = _pos select 0;

  // Iterate through all the positions in the _pos array to check if there is any closer
  // And if there is one, discard the old one and keep the new one
  {
    private _dis = _x distanceSqr _leader;
    if (_dis <= _closestDistance) then {
      _closestDistance = _dis;
      _spawnPos = _x;
    };
  } forEach _pos;
} else {
  // Else, choose a random one
  _spawnPos = selectRandom _pos;
};

// Get all possible QRF Groups to randomly choose one and get the data to be used to spawn the group with the specific loadouts for its units
private _allGrp = missionNamespace getVariable [_QRFGroups, createHashMap];

// If the group does not exist exit the function
if ((isNil "_allGrp") OR ((count (keys _allGrp)) isEqualTo 0)) exitWith {

private _text = ["[FROM ENEMY RADIO]","<t color='#E60000'>[ENEMY HQ] Negative, there no available units to send...</t>"];
// If there is not a position available to spawn the group, inform the players near the leader of the group and exit the script
_text remoteExec ["BIS_fnc_showSubtitle", (allPlayers distance (leader _grp)) <= 50, false];

};

// Get the data of a randomly selected QRF Group from the pool created with a fnc_groupCompiler instance
private _QRFGrpData = [_allGrp] call HSO_fnc_getQRFGroup;

/*======================== SPAWN QRF GROUP ====================================*/
private _QRFGrp = createGroup (side _grp);
{
  private _class = _x select 0;
  private _ld = _x select 1;

  private _newUnit = _QRFGrp createUnit [_class, _spawnPos, [], 5, "NONE"];
  _newUnit setUnitLoadout _ld;

} forEach _QRFGrpData;

// Create the waypoint for the group

// Code to be executed when the waypoint gets completed
private _onCompleted = str {
  if (!local this) exitWith {}; (group this) enableDynamicSimulation true; [group this, [getPosATL this, 100, 100, 0, false]] call CBA_fnc_taskSearchArea;
  };

// The actual waypoint
private _wp = _QRFGrp addWaypoint [getPosATL _leader, 30, -1, "QRFWaypoint"];
_wp setWaypointType "SAD"; // Type "Search And Destroy"
_wp setWaypointBehaviour "AWARE"; // Behaviour "AWARE"
_wp setWaypointSpeed "FULL";
_wp setWaypointCombatMode "YELLOW"; // Combat Mode "Fire At Will, Keep Formation"
_wp setWaypointStatements ["true", _onCompleted]; // The waypoint's statement

// Giving feedback to players close to the enemy leader that a QRF has been dispatched
private _text = ["[FROM ENEMY RADIO]","<t color='#E60000'>[ENEMY HQ] Roger that... Despatching QRF immediatelly...</t>"];
_text remoteExecCall ["BIS_fnc_showSubtitle", allPlayers select { (_x distance (leader _grp)) <= 50; }, false];

// If the mission params are set, the QRF Group will be able to call for a QRF Group itself
if (_canCall isEqualTo 1) then { [_QRFGrp] call HSO_fnc_callQRFEH; };
