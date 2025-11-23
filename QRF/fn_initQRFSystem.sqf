if (not isServer) exitWith { diag_log "The HSO_fnc_initQRFSystem function is executed only in the Server"; };

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
private _params = [_affectedSides, _delay, _pos, _QRFGroups, _closestQRF, _canCall];
missionNamespace setVariable ["HSO_QRFGroupCreatedEHParams", _params, true];

/*==================================== GROUP CREATED EH ADDITION ====================================*/

// Adds a "Group Created" EH to the mission to add the "Enemy Detected"
private _id = addMissionEventHandler ["GroupCreated", {
	params ["_grp"];
	
	private _handler = [] spawn {
		
		private _params = missionNamespace getVariable ["HSO_QRFGroupCreatedEHParams", []]; // Get the params stored in missionNamespace

		// Check if the side of the created group is one of the affected sides and if it is not, exit the script
		if ( not ((side _grp) in (_params select 0)) ) exitWith { terminate _thisScript; }; 


		// Remove the affected sides from the params array to pass only the needed ones to the function below
		_params deleteAt 0; 

		sleep 30; // Wait 30 seconds to ensure the group is fully created

		// Check if the group already has the EH added. If it has, exit the script
		private _EHAdded = _grp getVariable ["EnemyDetectedEHID", nil];
		if ( not (isNil "_EHAdded") ) exitWith { terminate _thisScript; }; 


		// Check if the group is set to be included in the QRF system. If not, exit the script
		if ( not (_grp getVariable ["includeGrpToQRFSystem", true]) ) exitWith { terminate _thisScript; }; 

		// Check if there is any player in the group. If there is, exit the script
		{
			if (isPlayer _x) exitWith { terminate _thisScript; }; 
		} count (units _grp);

		// If all the checkes are passed, call the function to add the EH
		_params = [_grp] + _params; // Add the group to the params array
		_params call HSO_fnc_callQRFEH; // Call the function to add the EH
	};
}];

// Store the EH ID in missionNamespace to be available for deletion later if needed
missionNamespace setVariable ["HSO_QRFGroupCreatedEHID", ["GroupCreated", _id], true];


// Check if pre-placed groups should be initialised for the QRF system
if (not _affectPrePlacedGrp) exitWith {};

/*==================================== INITIALISE PRE-PLACED GROUPS ====================================*/
// Call the function to initialise pre-placed groups for the QRF system
[_affectedSides] call HSO_fnc_initQRFSystemForPreplacedGrp;