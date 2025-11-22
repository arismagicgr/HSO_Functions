if (!isServer) exitWith { "The function is executed only in the Server"; };

params [
	["_affectedSides", [east, independent], [], [1,2,3,4]],
	["_affectPrePlacedGrp", true, [true]],
	["_delay", 10["alertTimeParam",15] call BIS_fnc_getParamValue, [0]],
	["_pos", "HSO_QRFspawnPositions", ["", objNull, []], [2,3]],
	["_QRFGroups", "HSO_QRFGroups", [""]],
	["_closestQRF", true, [false]],
	["_canCall", ["canCallQRFParam", 1] call BIS_fnc_getParamValue, [1]]
];

// Store the params in missionNamespace to be available to the EH code
missionNamespace setVariable ["HSO_QRFGroupCreatedEHParams", _this, true];

/*==================================== GROUP CREATED EH ADDITION ====================================*/

// Adds a "Group Created" EH to the mission to add the "Enemy Detected"
private _id = addMissionEventHandler ["GroupCreated", {
	params ["_grp"];
	
	private _handler = [] spawn {
		
		sleep 30; // Wait 5 seconds to ensure the group is fully created

		private _addEH = true;
		{
			if (isPlayer _x) exitWith { _addEH = false; };
		} count (units _grp);

		if !(_grp getVariable ["includeGrpToQRFSystem", true]) exitWith { terminate _thisScript; };

		if (_addEH) then {
			private _params = missionNamespace getVariable ["HSO_QRFGroupCreatedEHParams", []];
			_params = [_grp] + _params;
			_params call HSO_fnc_callQRFEH;
		};
	};
}];

missionNamespace setVariable ["HSO_QRFGroupCreatedEHID", ["GroupCreated", _id], true];