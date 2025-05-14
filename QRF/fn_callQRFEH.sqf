/*
* Adds an "Enemy Detected" Event Handler (EH) to a group to fire
* when an enemy group will be identified (knowsAbout >= 1.5) and
* after some time (_delay), the group will call a QRF if at least
* one of its units is still alive and not unconscious. The QRF group
* that will spawn at the closest QRF spawn position that are hold in a
* global variable in missionNamespace,
* will have _QRFCount number of units and their loadouts will be
* determined by a variable that was created with HSO_fnc_unitsCompiler function. The QRF group
* will get a waypoint (wp) of type "Search And Destroy (SAD)" close to group
* leader of the group that "call" the QRF, and it will be flagged as
* "enableDynamicSimulation true" when it arrives at its waypoint.
* When the waypoint is completed, it will transition to CBA_fnc_taskSearchArea
*
* Parameters:
* 0) _group [string, object] - Default = grpNull: The group the EH will be attached to.
* 1) _delay [number] - Default = 15: The delay that the alerted's group action
*   will delay to give players the chance to neutralise the
*   group before it acts (for example, before they call a QRF).
* 2) _pos [string, array with 2 or 3 values, object] - Default = "LNO_enemySpawnPos": The position the newly spawned group
*   will spawn (in case the action is calling a QRF for example).
*   [String]: If the value is a string, it has to be the name of a global
*   variable in missionNamespace that will hold objects that the function
*   will get its positions (getPosATL) to use them as possible spawn positions.
*   [object]: If it is an object, its position (getPosATL) will be used.
*   [array]: If it is an array, it has to be in position format [x,y] or [x,y,z]
* 3) _QRFCount [number] - Default = (round (random [4,6,8])): Number of units in the newly spawned group.
* 4) _canCallQRF [boolean] - Default = true: If the newly spawned group can also call a QRF.
*   It is recommended to set true (as its default value) but it became
*   a parameter to avoid flooding the mission with AI.
*
* Example:
* [group player, 15, "HSO_QRFSpawnPositions", 12, true] call HSO_fnc_callQRFEH;
*/


params [
  ["_group", grpNull, [grpNull, objNull]], // The group that EH will be attached and will "call" for a QRF
  ["_delay", ["alertTime",15] call BIS_fnc_getParamValue, [0]], // The time that players will to neutralise the group's units before a QRF is called
  ["_pos", "HSO_QRFspawnPositions", ["", objNull, []], [2,3]], // The position of the spawned group will be spawned
  ["_QRFCount", ["qrfCount", 12] call BIS_fnc_getParamValue, [0]], // The unit count of the QRF group
  ["_canCall", ["canCallQRF", 1] call BIS_fnc_getParamValue, [true]] // Determines if the QRF group can call another QRF if it identifies a player
];

// Check if the entity that was passed is local. If it is not, the funciton exit
if !(local _group) exitWith { "The function is meant to be executed only where group/unit is local." };

// If the entity that was passed is a unit, the group of the unit is "taken"
if (_group isEqualType objNull) then { _group = group _group; };

// The function params are added in group's namespace to be available to EH code
_this = [_group, _delay, _pos, _minDis, _QRFCount, _ldVarName, _canCall, _isHunter];
_group setVariable ["enemyDetectedEHParams", _this];


// Adds an EH to the group to execute the QRF function when an enemy is detected
_group addEventHandler ["EnemyDetected", {
	params ["_grp", "_target"];

  // Checks if the side of the identified target is enemy, if the mission maker wants the target to be a player and if the variable to disable the ability of the unit to call QRF is enabled
  if (([side _target, side _grp] call BIS_fnc_sideIsEnemy) AND (_grp getVariable ["canCallQRF", true])) then {
    // Get the params of the function to pass them to the spawn QRF function
    private _params = _grp getVariable ["enemyDetectedEHParams", []];
    // And adds the identified target to the params
    _params pushBack _target;
    // Removes the EH so it will trigger only once. The rest will be handled by the function below
    _grp removeEventHandler [_thisEvent, _thisEventHandler];

    // Call the function that will call the QRF
    _params call HSO_fnc_callQRF;
  };
}];
