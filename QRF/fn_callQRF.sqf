params [
  ["_grp", grpNull, [grpNull]], // Group that identified the target
  ["_delay", 10, [0]], // Time that the code will wait to "immitate" the time is needed to reach out for the radio and call QRF
  ["_pos", "HSO_QRFspawnPositions", [""]], // The variable in missionNamespace that holds the possible enemy spawn positions (created by LNO_fnc_registerHelperObjects in editor)
  ["_QRFGroups", "HSO_QRFGroups", [""]], // The variable name that holds the hashMap with the QRF Groups composition created by the HSO_fnc_groupCompiler
  ["_closestQRF", false, [false]], // If the QRF will spawn to the closes possible position
  ["_canCall", ["canCallQRF", 1] call BIS_fnc_getParamValue, [1]], // Determines if the QRF group can call another QRF if it identifies a player
  ["_target", objNull, [objNull]] // The unit/player that was indentified.
];

private _params = [_grp,_delay,_pos,_QRFGroups,_closestQRF,_canCall,_target];
private _QRFCalled = false;
// Delay to give players the chance to neutralise the target
sleep _delay;

// Get the alive units of the group
private _alive = (units _grp) select { alive _x; };

// Check if all units are dead and exit the function
if ((count _alive) isEqualTo 0) exitWith {};

// Check if there is at least on unit alive and not incapacitated and call a QRF
{ if ((lifeState _x) isNotEqualTo "INCAPACITATED") exitWith {
   [_grp, _pos, _QRFGroups, _closestQRF, _canCall] call HSO_fnc_spawnQRF;
   _QRFCalled = true;
 };
} count _alive;

// Else call the function again to start over the process
if (!(_QRFCalled)) then {
  _params spawn HSO_fnc_callQRF;
};
