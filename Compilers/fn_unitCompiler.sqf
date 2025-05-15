if !(isServer) exitWith { "The function is executed only in the Server"; };
params [
  ["_logic", objNull,[objNull]],
  ["_varName", "HSO_compiledUnits", [""]]
];

private _hash = createHashMap;

{
  private _grp = group _x;
  _hash set [typeOf _x, getUnitLoadout _x];
  deleteVehicle _x;
  if ((count (units _grp)) isEqualTo 0) then  { deleteGroup _grp; };
} forEach synchronizedObjects _logic;

deleteVehicle _logic;

missionNamespace setVariable [_varName, _hash, true];

_hash;
