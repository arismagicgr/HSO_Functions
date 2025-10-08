params [
    ["_pos", objNull, [objNull,"",[]], [2,3]]
    ["_distance", 0, [0]]
];

switch (true) do {
    case (_pos isEqualType objNull): {
        private _zAxis = (_pos getPosATL) select 2;
        _pos = _pos getPos [_distance, getDir _pos];
        _pos set [2, _zAxis];
    };

    case (_pos isEqualType ""): { _pos = getMarkerPos _pos; };
};

private _cutter = "Land_ClutterCutter_small_F" createVehicle _pos;
sleep 1;
deleteVehicle _cutter;