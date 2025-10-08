params [
  ["_obj", objNull, [objNull]],
  ["_duration", 5, [0]],
  ["_distance", 1, [0]]
];


private _id = _obj getVariable ["HSO_fnc_cutGrassInteractionID", -1];
if (_id isNotEqualTo -1) exitWith { diag_log (format ["The %1 already has a cut grass interaction added. Function exited", _obj]); };

private _text = "<t color='#E60000'>Cut Grass in front of you</t>";

_id = [
  _obj,
  _text,
  "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa",
  "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa",
  "true",
  "true",
  {}, // Code start
  {}, // Code progress
  { [_caller, (_this select 3) select 0] call HSO_fnc_cutGrass; }, // Code completed
  {}, // Code interrupted
  [_distance], // Params
  _duration, // Duration
  0, // Priority
  false, // Remove completed
  false, // Show unconscious
  false // Show window
] call BIS_fnc_holdActionAdd;

_obj setVariable ["HSO_cutGrassInteractionID", _id];
] call BIS_fnc_holdActionAdd;
<<<<<<< HEAD

_obj setVariable ["HSO_cutGrassInteractionID", _id];
=======
>>>>>>> origin/Main
