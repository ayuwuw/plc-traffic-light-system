FUNCTION_BLOCK FB_Stoplight
VAR_INPUT
	xRun				: BOOL := FALSE;
	
	xPedestrianRequest	: BOOL;
	
	tGreen				: TIME;
	tYellow 			: TIME;
	tRed 				: TIME;
END_VAR
VAR_OUTPUT	
	xGreen				: BOOL;
	xYellow				: BOOL;
	xRed				: BOOL;
END_VAR
VAR
	eState				: E_StoplightState := E_StoplightState.OFF;
	
	rtPedestrian		: R_TRIG;
	
	tonGreen 			: TON;
	tonYellow 			: TON;
	tonRed 				: TON;
END_VAR


IF NOT xRun THEN
	eState := E_StoplightState.OFF;
END_IF

rtPedestrian(CLK := xPedestrianRequest);

tonGreen(
	IN := (eState = E_StoplightState.GREEN), 
	PT := tGreen
);

tonYellow(
	IN := (eState = E_StoplightState.YELLOW), 
	PT := tYellow
);

tonRed(
	IN := (eState = E_StoplightState.RED), 
	PT := tRed
);

IF xRun THEN
	CASE eState OF
		E_StoplightState.OFF:
			eState := E_StoplightState.GREEN;
			
		E_StoplightState.GREEN:
			IF rtPedestrian.Q OR tonGreen.Q THEN
				eState := E_StoplightState.YELLOW;
			END_IF
	
		E_StoplightState.YELLOW:
			IF tonYellow.Q THEN
				eState := E_StoplightState.RED;
			END_IF
	
		E_StoplightState.RED:
			IF tonRed.Q THEN
				eState := E_StoplightState.GREEN;
			END_IF
	END_CASE
END_IF

xGreen := FALSE;
xYellow := FALSE;
xRed := FALSE;

CASE eState OF
	E_StoplightState.GREEN:
		xGreen := TRUE;
		
	E_StoplightState.YELLOW:
		xYellow := TRUE;
		
	E_StoplightState.RED:
		xRed := TRUE;
		
	E_StoplightState.OFF:
		// All lights off 
END_CASE
