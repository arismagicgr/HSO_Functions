params [
 ["_varName", "HSO_QRFGroups", [""]]
];

private _hash = missionNamespace getVariable [_varName, createHashMap];
private _allGrp = keys _hash;
if ((count _allGrp) isEqualTo 0) exitWith { "No groups were found" };
private _grp = selectRandom _allGrp;
private _data = _hash get _grp;
private _classNames = [];
private _loadouts = [];

{
  _classNames pushBack (_x select 0);
  _loadouts pushBack (_x select 1);
} forEach _data;

[_classNames, _loadouts];
