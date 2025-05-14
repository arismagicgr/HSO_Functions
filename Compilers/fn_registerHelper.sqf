if !(isServer) exitWith { "The function is executed only in the Server"; };
params [
  ["_obj", objNull,[objNull]],
  ["_varName", "HSO_QRFspawnPositions"]
];

private _arr = missionNamespace getVariable [_varName, []];
_arr pushBackUnique _obj;
missionNamespace setVariable [_varName, _arr, true];

_arr;
