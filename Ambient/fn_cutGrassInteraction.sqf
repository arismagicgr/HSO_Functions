params [
	["_player", objNull, [objNull]],

    ["_duration", 5, [0]],
    ["_distance", 1, [0]]

    ["_duration", 5, [0]]

];

private _text = "<t color='#E60000'>Cut Grass in front of you</t>";

[
  _player,
  _text,
  "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa",
  "\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa",
  "true",
  "true",
  {}, // Code start
  {}, // Code progress
  { 
    [_caller, (_this select 3) select 0] call HSO_fnc_cutGrass; 
  }, // Code completed
  {}, // Code interrupted
  [_distance], // Params
  { [_caller] call HSO_fnc_cutGrass; }, // Code completed
  {}, // Code interrupted
  [], // Params
  _duration, // Duration
  0, // Priority
  false, // Remove completed
  false, // Show unconscious
  false // Show window
] call BIS_fnc_holdActionAdd;