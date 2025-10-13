params [
 ["_varName", "HSO_QRFGroups", [""]]
];

private _hash = missionNamespace getVariable [_varName, createHashMap];
private _allGrp = keys _hash;
if ((count _allGrp) isEqualTo 0) exitWith { nil };
private _grp = selectRandom _allGrp;
private _data = _hash get _grp;

data;
