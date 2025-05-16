if (!isServer) exitWith {};

params [
  ["_tick", ["LNO_cacheSystemBatchIteration", 1] call BIS_fnc_getParamValue, [0]],
  ["_batchSize", ["LNO_cacheSystemBatchSize",10] call BIS_fnc_getParamValue, [0]]
];
private _params = [_tick, _batchSize];
private _groups = allGroups;
private _count = count _groups;
private _startIndex = 0;

while {
  (_startIndex < _count) AND (missionNamespace getVariable ["LNO_cacheSystemRunning", false])
} do {
  // Set the end index according to batch size
  private _endIndex = _startIndex + (_batchSize - 1);
  // Fail safe to avoid getting over group count. Get the smaller nubmer between the _endIndex and the (count - 1)
  // Which is the total number of groups (since the first index is 0)
  private _actualEnd = _endIndex min (_count -1);

  for "_i" from _startIndex to _actualEnd do {
    // Get the group that corresponds to the index
    private _grp = _groups select _i;

    if ((!isNull _grp) AND ((count (units _grp)) isNotEqualTo 0)) then {
      [_grp] call LNO_fnc_cacheCheckGroup;
    };

    // Update the total count to make sure that our groups array is up to date
    _groups = allGroups;
    _count = count _groups;

    // Update the _startIndex to get the next batch of groups
    _startIndex = _startIndex + (_batchSize - 1);

    // Wait
    sleep _tick;
  };
};

if (missionNamespace getVariable ["LNO_cacheSystemRunning", false]) then {
  _params spawn LNO_fnc_cacheBatchProcessor;
};
