params [
  ["_entity", grpNull, [grpNull, objNull]],
  ["_varName", "HSO_enemyUnits", [""]]
];

private _hash = missionNamespace getVariable _varName;
if (isNil "_hash") exitWith { "No loadout data was found" };

private _units = [];
switch (true) do {
  case (_entity isEqualType grpNull): { _units = units _entity; };
  case (_entity isEqualType objNull): { _units = [_units]; };
};

{
  private _class = typeOf _x;
  private _ld = _hash get _class;
  _x setUnitLoadout [_ld, true];
} forEach _units;
