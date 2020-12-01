Scriptname SkyMp_OreFurnitureScript extends ObjectReference  
{script for furniture which the player can use to get resources}


; Weapon Property RequiredWeapon Auto  
; {required for player to use - optional}

; Message Property FailureMessage Auto  
; {Message to say why you can't use this without RequiredWeapon}

; MiscObject Property Resource Auto  
; {what you get from using this furniture}

; int Property ResourceCount = 1 Auto
; {how many resources you get per use}

objectReference property lastActivateRef auto Hidden
{tracks the last triggeringRef}

objectReference property objSelf auto hidden
{pointer to this reference, set in script}

bool property isRegisteredForEvents = false auto hidden
{bool to track if this is registered for events}

bool property canBeActivated = true auto hidden

idle property PickaxeExit auto

bool property playerIsLeavingFurniture = false auto hidden

int property Da = 5 auto hidden
{bool to track if this is registered for events}

Function SetPlayerIsLeavingFurniture(bool ValuePlayerIsLeavingFurniture)
    playerIsLeavingFurniture = ValuePlayerIsLeavingFurniture
EndFunction

bool Function GetPlayerIsLeavingFurniture()
    return playerIsLeavingFurniture
EndFunction

bool property playerIsInFurniture = false auto hidden

faction property CurrentFollowerFaction auto
{Used to handle player followers using the furniture object}

globalvariable property MiningSkillIncrement auto

; Actor Game.GetPlayer()

; Function SetGame.GetPlayer()(Actor Game.GetPlayer()Value)
; 	Game.GetPlayer() = Game.GetPlayer()Value
; EndFunction
;===================================================================
;;EVENT BLOCK
;===================================================================
Event OnLoad()
	BlockActivation(true)
	objSelf = self as objectReference
	if (isFurnitureInUse())
		goToState("busy")
	endif
endEvent

Event OnUnload()
	; safety measure
	UnregisterForEvents()
endEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
; 	debug.trace(self + ": animation event received=" + asEventName)
	
	;if the animation event we've recieved is addToInventory activate our mineOreVein with
	;the furniture as the activator to tell it to pay out ore
	; if (asEventName == "AddToInventory")
	; 	;Game.GetPlayer().AddItem(Resource, ResourceCount)
	; 	lastActivateRef.activate(objSelf)
	; endif	

	
	if (asEventName == "IdleFurnitureExit" || asEventName == "IdlePickaxeExit" || asEventName == "IdlePickaxeFloorExit" || asEventName == "IdlePickaxeTableExit")
		UnregisterForEvents()
	endif
endEvent

;===================================================================
;;STATE BLOCK
;===================================================================

auto STATE normal
	event onBeginState()
		canBeActivated = true
; 		debug.Trace(self + " is in state normal")
	endEvent
	
	Event OnActivate(ObjectReference akActionRef)
		; Game.GetPlayer() = akActionRef As Actor
		if (canBeActivated)
			canBeActivated = False
			gotoState("busy")
; 			debug.trace(self + ": OnActivate in state normal by " + akActionRef)
			if (akActionRef == Game.GetPlayer() && !isFurnitureInUse())
; 				debug.trace(self + ": was activated by the player in state normal, furniture not in use")
				RegisterForEvents()
				Activate(akActionRef, true)
		
			elseif (akActionRef == Game.GetPlayer())
; 				debug.Trace(self + ": has been activated by the player while in use")
				;just activate it
				;goToState("busy")
				Activate(akActionRef, true)
; 				;debug.trace(self + "NPC activation END")
			else
				;goToState("busy")
				Activate(akActionRef, true)
			endif
		endif
		canBeActivated = true
	endEvent
endState

STATE busy
	; do nothing
	event onBeginState()
		canBeActivated = True
	endEvent
	
	event onActivate(objectReference akActionRef)
		; Game.GetPlayer() = akActionRef As Actor
		if (canBeActivated && isFurnitureInUse())
			canBeActivated = False
; 			debug.Trace(self + ": has recieved activation in busy state from " + akActionRef)
			if (isRegisteredForEvents)
				if (akActionRef == lastActivateRef)
; 					debug.Trace(self + ": is trying to kick player out of furniture")
					; Game.GetPlayer().PlayIdle(PickaxeExit)
					; Activate(Game.GetPlayer(), true)
					playerIsLeavingFurniture = True
					goToState("reseting")
				elseif (akActionRef == Game.GetPlayer())
; 					debug.Trace(self + ": player is trying to leave furniture")
					; Game.GetPlayer().PlayIdle(PickaxeExit)
					; Activate(Game.GetPlayer(), true)
					playerIsLeavingFurniture = True
					goToState("reseting")
				endif
			elseif (akActionRef == Game.GetPlayer())
				Activate(Game.GetPlayer(), true)
			else
				;Activate(akActivator, true)
			endif
		elseif (!isFurnitureInUse() && akActionRef == Game.GetPlayer())
; 			debug.trace(self + ": was activated by the player")
			RegisterForEvents()
			Activate(akActionRef, true)
		endif
		canBeActivated = true
	endEvent
endState

state reseting
	event onBeginState()
; 		debug.Trace(self + " is in state reseting")
		if (playerIsLeavingFurniture)
			playerIsLeavingFurniture = false
			Game.GetPlayer().PlayIdle(PickaxeExit)
		else
			UnregisterForEvents()
		endif
		;Activate(Game.GetPlayer(), true)
		
		;UnregisterForEvents()
	endEvent
	
	; event onActivate(objectReference akActionRef)
		; UnregisterForEvents()
	; endEvent
endState

state Depleted
	event onBeginState()
		isRegisteredForEvents = True
		UnregisterForEvents()
	endEvent
	
	event onActivate(objectReference akActionRef)
; 		debug.Trace(self + ": has recieved activation in state Depleted from " + akActionRef)
	endEvent
endState

;===================================================================
;;FUNCTION BLOCK
;===================================================================

function goToDepletedState()
	goToState("Depleted")
endFunction

function RegisterForEvents()
	; centralize this
	if (!isRegisteredForEvents)
		isRegisteredForEvents = True
		RegisterForAnimationEvent(Game.GetPlayer(), "AddToInventory")
		RegisterForAnimationEvent(Game.GetPlayer(), "IdlePickaxeExit")
		RegisterForAnimationEvent(Game.GetPlayer(), "IdlePickaxeFloorExit")
		RegisterForAnimationEvent(Game.GetPlayer(), "IdlePickaxeTableExit")
		RegisterForAnimationEvent(Game.GetPlayer(), "IdleFurnitureExit")
	endif
endFunction

function UnregisterForEvents()
	; centralize this
	; It is perfectly safe to unregister for events you never registered for, however
	; this function is called as part of OnUnload, and if this object isn't persistent
	; then it may be deleted by the time OnUnload runs, and these function calls will
	; fail. Since RegisterForAnimationEvent persists us, we know it will be safe to
	; call Unregister if we've previously Registered, even if called as a part of
	; OnUnload
; 	debug.Trace(self + " is attempting to unregister for anim events")
	if (isRegisteredForEvents)
		isRegisteredForEvents = false
		UnRegisterForAnimationEvent(Game.GetPlayer(), "AddToInventory")
		UnRegisterForAnimationEvent(Game.GetPlayer(), "IdlePickaxeExit")
		UnRegisterForAnimationEvent(Game.GetPlayer(), "IdlePickaxeFloorExit")
		UnRegisterForAnimationEvent(Game.GetPlayer(), "IdlePickaxeTableExit")
		UnRegisterForAnimationEvent(Game.GetPlayer(), "IdleFurnitureExit")
	endif
	gotoState("normal")
	canBeActivated = True
endFunction

