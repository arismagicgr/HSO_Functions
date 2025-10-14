if (!isServer) exitWith { "The function is executed only in the Server"; };

params [
	["_delay", 10["alertTimeParam",15] call BIS_fnc_getParamValue, [0]],
	["_pos", "HSO_QRFspawnPositions", ["", objNull, []], [2,3]],
	["_QRFGroups", "HSO_QRFGroups", [""]],
	["_closestQRF", true, [false]],
	["_canCall", ["canCallQRFParam", 1] call BIS_fnc_getParamValue, [1]]
];

missionNamespace setVariable ["HSO_QRFGroupCreatedEHParams", _this, true];

private _id = addMissionEventHandler ["GroupCreated", {
	params ["_grp"];
	private _handler = [] spawn {
		sleep 10;
		private _addEH = true;
		{
			if (isPlayer _x) exitWith { _addEH = false; };
		} count (units _grp);

		if (_addEH) then {
			private _params = missionNamespace getVariable ["HSO_QRFGroupCreatedEHParams", []];
			_params = [_grp] append _params;
			_params call HSO_fnc_callQRFEH;
		};
	};
}];

missionNamespace setVariable ["HSO_QRFGroupCreatedEHID", ["GroupCreated", _id], true];