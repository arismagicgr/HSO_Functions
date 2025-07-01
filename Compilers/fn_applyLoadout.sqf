params [
  ["_entity", grpNull, [grpNull, objNull]],
  ["_varName", "HSO_compiledUnits", [""]]
];

private _hash = missionNamespace getVariable _varName;
if (isNil "_hash") exitWith { "No loadout data was found" };

private _units = [_entity];
if (_entity isEqualType grpNull) then { _units = units _entity; };

{
  private _class = typeOf _x;
  private _ld = _hash get _class;
  _x setUnitLoadout [_ld, true];
} forEach _units;
