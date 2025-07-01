params [
    ["_unit", objNull, [objNull]]
    ["_distance", 1, [0]]
];

private _pos = _unit getPos [_distance, getDir _unit];
private _zAxis = (_unit getPosATL) select 2;
_pos set [2, _zAxis];

private _cutter = "Land_ClutterCutter_small_F" createVehicle _pos;
sleep 1;
deleteVehicle _cutter;