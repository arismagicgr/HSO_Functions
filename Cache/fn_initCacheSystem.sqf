if (!isServer) exitWith {};

params [
  ["_tick", ["HSO_cacheSystemBatchIteration", 1] call BIS_fnc_getParamValue, [0]],
  ["_batchSize", ["HSO_cacheSystemBatchSize",10] call BIS_fnc_getParamValue, [0]]
];

private _params = [_tick, _batchSize];
private _outcome = -1;
private _run = missionNamespace getVariable ["HSO_cacheSystemRunning", false];

if !(_run) then {

  // Executes the function that iterats through all existing groups and adds the appropriate EH that is used by HSO Cache System
  [] call HSO_fnc_addCacheEHToAllGroups;


  // Execute the function that handles the proper addition of the mission EH that manages group creation for the HSO Cache System
  [] call HSO_fnc_addCacheMissionEH;

  // Execute the function that loops through allGroups and check them.
  _params spawn HSO_fnc_cacheBatchProcessor;

  // Set the "flag" for the initialization to true so we avoid duplicate actions
  missionNamespace setVariable ["HSO_cacheSystemRunning", true, true];

  // Set the _outcome to true
  _outcome = true;
} else {

  // In case the system is already initialized and not disabled a messsage is sent to .rpt and the
  diag_log "HSO Cache System already running. Skipping initialization.";

  // Set the _outcome to false to know that the initialization was not happened again
  _outcome = false;
};

/* Returns _outcome according to the execution or not of the function
* Values:
*
* True = System initialized,
* False = system was not initialized because it has been initialized and running,
* -1 = The "if" structure was not executed. Check the functions script
*
*/
_outcome;
