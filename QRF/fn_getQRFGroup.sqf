params [
 ["_varName", "HSO_QRFGroups", [""]]
];

private _hash = missionNamespace getVariable [_varName, createHashMap];
private _allGrp = keys _hash;
if ((count _allGrp) isEqualTo 0) exitWith { nil };
private _grp = selectRandom _allGrp;
private _data = _hash get _grp;
private _unitsData = [];

{
  private _class = _x select 0;
  private _ld = _x select 1;
  _unitsData pushBack [_class, _ld];
} forEach _data;

_unitsData;
