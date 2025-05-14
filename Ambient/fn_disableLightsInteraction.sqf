params [
  ["_obj",objNull,[objNull]],
  ["_radius", ["disableLightsRadius",1000] call BIS_fnc_getParamValue, [0]]
];

_obj setVariable ["radius", _radius];
private _text = "<t color='#E60000'>Disable Lights</t>";
private _conditionShow = "_this distance _target <= 5 AND (alive _target)";
private _conditionShow = "_caller distance _target <= 5 AND (alive _target) AND (cursorObject isEqualTo _target)";


[
  _obj,
  _text,
  "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa",
  "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa",
  _conditionShow,
  _conditionProgress,
  { [(rank _caller) + " " + (name _caller), "<t color='#E60000'>Turning lights off...</t>"] remoteExec ["BIS_fnc_showSubtitle", allPlayers, false]; }, // Code start
  {}, // Code progress
  {
    private _radius = _this select 3 select 0;
    [_target, _radius] call HSO_fnc_disableLights;
    _target setDamage 1;
    [(rank _caller) + " " + (name _caller), "<t color='#E60000'>Lights off...</t>"] remoteExec ["BIS_fnc_showSubtitle", allPlayers, false];
  }, // Code completed
  {[(rank _caller) + " " + (name _caller), "<t color='#E60000'>I was interrupted... Have to start again...</t>"] remoteExec ["BIS_fnc_showSubtitle", allPlayers, false];}, // Code interrupted
  [_radius], // Params
  10, // Duration
  100, // Priority
  false, // Remove completed
  false, // Show unconscious
  true // Show window
] call BIS_fnc_holdActionAdd;

_obj addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
  private _radius = _unit getVariable ["radius", ["disableLightsRadius",1000] call BIS_fnc_getParamValue];
  [_unit, _radius] call HSO_fnc_disableLights;
}];
