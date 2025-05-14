params [
  ["_grp", grpNull, [grpNull]], // The group that "called" the QRF
  ["_pos", "HSO_QRFspawnPositions", [""]], // Variable name in missionNamespace that holds the objects that act as possible enemy spawn positions
  ["_QRFGroups", "HSO_QRFGroups", [""]], // Variable Name that holds the HashMap of all the groups that can be used as QRF
  ["_canCallQRF", true, [true]] // Determines if the QRF group can call another QRF group if it identifies a player
];

// Get the leader of the group to do the calculations and get the position for the waypoint
private _leader = leader _grp;

// Find the closest QRF spawn position
private _spawnPositions = missionNamespace [_pos, []];

if ((count _spawnPositions) isEqualTo 0) exitWith {

  private _text = ["[FROM ENEMY RADIO]","<t color='#E60000'>[ENEMY HQ] Negative, is not possible to send QRF...</t>"];
  // If there is not a position available to spawn the group, inform the players near the leader of the group and exit the script
  _text remoteExec ["BIS_fnc_showSubtitle", (allPlayers distance (leader _grp)) <= 50, false];

};

// Find the QRF Spawn Position closest to the leader of the group that called QRF. This will be used as spawn position
_closestDistance = _leader distanceSqr (_spawnPositions select 0);
_pos = _spawnPositions select 0;

{
  private _dis = _x distanceSqr _leader;
  if (_dis <= _minDis) then {
    _minDis = _dis;
    _pos = _x;
  };
} forEach _spawnPositions;


// Get all possible QRF Groups to randomly choose one and get the data to be used to spawn the group with the specific loadouts for its units
private _allGrp = missionNamespace getVariable [_QRFGroups, createHashMap];

// If the group does not exist exit the function
if (isNil "_allGrp") exitWith { "There are no groups available" };

// Get the data of a randomly selected QRF Group from the pool created with a fnc_groupCompiler instance
private _QRFGrpData = [_allGrp] call HSO_fnc_getQRFGroup;
private _toSpawn = _QRFGrpData select 0; // Class names of the units
private _loadouts = _QRFGrpData select 1; // The corresponding loadouts for these units

// Create an array with ranks since it is needed for BIS_fnc_spawnGroup
private _ranks = [];
{_ranks pushBack "PRIVATE";} forEach _toSpawn;

/*======================== SPAWN QRF GROUP ====================================*/

// BIS_fnc_spawnGroup
private _QRFGrp = [
  _pos, // Position to spawn the group
  side _grp, // Side of the QRF group
  _toSpawn, // That's the hard part
  [], // Relative positions (??)
  _ranks, // Ranks of the group members
  [0.35,0.75], // Skill range
  [1,1], // Ammo range
  [count _toSpawn,1], // Random Controls [minUnits, chanceForTheRestToSpawn]
  0, // Facing of the group
  false, // Precise position
  nil // Max vehicles
] call BIS_fnc_spawnGroup;

// Apply the loadouts that were set by mission maker with fnc_groupCompiler
{
  _x setUnitLoadout (_loadouts select _forEachIndex);
} forEach (units _QRFGrp)


// Create the waypoint for the groups

// Code to be executed when the waypoint gets completed
private _onCompleted = "if !(local this) exitWith {}; (group this) enableDynamicSimulation true; [group this, [getPosATL this, 100, 100, 0, false]] call CBA_fnc_taskSearchArea;"

// The actual waypoint
private _wp = _QRFGrp addWaypoint [getPosATL _leader, 30, -1, "QRFWaypoint"];
_wp setWaypointType "SAD"; // Type "Search And Destroy"
_wp setWaypointBehaviour "AWARE"; // Behaviour "AWARE"
_wp setWaypointCombatMode "RED"; // Combat Mode "Fire At Will, Break Formation"
_wp setWaypointStatements ["true", _onCompleted]; // The waypoint's statement

// Giving feedback to players close to the enemy leader that a QRF has been dispatched
private _text = ["[FROM ENEMY RADIO]","<t color='#E60000'>[ENEMY HQ] Roger that... Despatching QRF immediatelly...</t>"];
_text remoteExecCall ["BIS_fnc_showSubtitle", allPlayers select { (_x distance (leader _grp)) <= 50; }, false];

// If the mission params are set, the QRF Group will be able to call for a QRF Group itself
if (_canCallQRF isEqualTo 1) then { [_QRFGrp] call HSO_fnc_callQRFEH; };
