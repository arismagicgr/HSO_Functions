if !(isServer) exitWith { "The function is executed only in the Server"; };

addMissionEventHandler ["GroupCreated", {
	params ["_group"];
	private _handler = [] spawn {
		sleep 10;
		private _addEH = true;
		{
			if (isPlayer _x) exitWith { _addEH = false; };
		} count (units _group);

		if (_addEH) then { [_group] call HSO_fnc_callQRFEH; };
	};
}];
