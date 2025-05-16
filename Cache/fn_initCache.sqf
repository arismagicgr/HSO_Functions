if (!isServer) exitWith {};

params [
  ["_tick", ["LNO_cacheSystemBatchIteration", 1] call BIS_fnc_getParamValue, [0]],
  ["_batchSize", ["LNO_cacheSystemBatchSize",10] call BIS_fnc_getParamValue, [0]]
];

private _params = [_tick, _batchSize];

private _run = missionNamespace getVariable ["LNO_cacheSystemRunning", false];

if !(_run) then {
  _params spawn LNO_fnc_batchProcessor;
} else {
  diag_log "LNO Cache System already running. Skipping initialization.";
};
