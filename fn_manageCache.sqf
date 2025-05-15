params [
  ["_grp", grpNull, [grpNull]],
  ["_forceUncache", true, [true]]
];

private _grpBehaviour = combatBehaviour _grp;
private _isNearPlayer = [_grp] call LNO_fnc_isNearPlayer;
private _inCombat = _grpBehaviour isEqualTo "COMBAT";
private _exclude = _grp getVariable ["LNO_excludeFromCache", false];

if (_nearPlayer OR _inCombat OR _forceUncache OR _exclude) exitWith {
  if ([_grp] call LNO_fnc_getCacheState) then { [_grp] call LNO_fnc_decachGroup; };
};

[_grp] call LNO_fnc_cacheGroup;

_grp;
