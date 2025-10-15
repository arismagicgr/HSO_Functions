params [
  ["_group", grpNull, [grpNull, objNull]], // The group that EH will be attached and will "call" for a QRF
  ["_delay", ["alertTimeParam",15] call BIS_fnc_getParamValue, [0]], // The time that players will to neutralise the group's units before a QRF is called
  ["_pos", "HSO_QRFspawnPositions", ["", objNull, []], [2,3]], // The position of the spawned group will be spawned
  ["_QRFGroups", "HSO_QRFGroups", [""]], // The unit count of the QRF group
  ["_closestQRF", true, [false]], // If the QRF will spawn from the closest position available
  ["_canCall", ["canCallQRFParam", 1] call BIS_fnc_getParamValue, [1]] // Determines if the QRF group can call another QRF if it identifies a player
];

// Check if the entity that was passed is local. If it is not, the functton exits
if !(local _group) exitWith { "The function is meant to be executed only where group/unit is local." };

// If the entity that was passed is a unit, the group of the unit is "taken"
if (_group isEqualType objNull) then { _group = group _group; };

if (_group getVariable ["enemyDetectedEHAdded", false]) exitWith { "This group already has an ""Enemy Detected EH"". No EH was added"; };

// The function params are added in group's namespace to be available to EH code
_this = [_group, _delay, _pos, _QRFGroups, _closestQRF, _canCall];
_group setVariable ["enemyDetectedEHParams", _this];


// Adds an EH to the group to execute the QRF function when an enemy is detected
private _id = _group addEventHandler ["EnemyDetected", {
	params ["_grp", "_target"];

  // Checks if the variable to disable the ability of the unit to call QRF is enabled
  if (_grp getVariable ["canCallQRF", true]) then {
    // Get the params of the function to pass them to the spawn QRF function
    private _params = _grp getVariable ["enemyDetectedEHParams", []];
    
    // Removes the EH so it will trigger only once. The rest will be handled by the function below
    _grp removeEventHandler [_thisEvent, _thisEventHandler];

    // Remove the "flag"
    _group setVariable ["enemyDetectedEHAdded", false];

    // Call the function that will call the QRF
    _params call HSO_fnc_callQRF;
  };
}];

// Add a "flag" in group's namespace to avoid adding another "EnemyDetected" EH
_group setVariable ["enemyDetectedEHAdded", true];

// Store the EH ID in group's namespace to be available for deletion later if needed
_group setVariable ["enemyDetectedEHID, ["EnemyDetected", _id]];

true;



