params [
  ["_source", objNull, [objNull, ""]],
  ["_radius", ["disableLightsRadius",1000] call BIS_fnc_getParamValue, [0]]
];

switch (true) do {
  case (_source isEqualType ""): { _source = getMarkerPos _source; };
  case (_source isEqualType objNull): { _source = getPosATL _source; };
};

private _lamps = _source nearObjects ["Lamps_Base_F", _radius];

{
  _x setDamage 0.99;
} forEach _lamps;

true;
