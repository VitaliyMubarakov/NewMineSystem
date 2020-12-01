Scriptname SkyMp_OreMineSystem extends ObjectReference  
{ custom ore system based on default skyrim MineOreScript }

sound property oreTakeSound auto
{ sound played when Ore is acquired }

formlist property mineOreToolsList auto
{ Optional: Player must have at least one item from this formlist to interact }

Message Property FailureMessage Auto  
{ Message to say why you can't use this without RequiredWeapon }

Message Property DepletedMessage Auto  
{ Message to say that this vein is depleted }

MiscObject Property Ore Auto  
{ what you get from this Ore Vein }

LeveledItem property lItemGems10 auto
{ Optional: Gems that may be mined along with ore }

int Property ResourceCount = 1 Auto
{ how many resources you get per drop }

int Property FullnessOreCount = 1000 Auto 
{ strength of ore }

int Property OreHealCount = 1 Auto 
{ amount of regeneration for each sec }

float Property modFatiguePerSec = 1.0 Auto 
{ amount of modFatigue for each sec }

int Property DamageFullnessOreCountPerSec = 20 Auto 
{ reduce fullness of ore each second when player is mining }

; int property StrikesNeed = 12 Auto
; { how many times this is struck before giving a resource } 

int property TimeSecTwo = 7 Auto
{ how many times this is struck before giving a resource } 

int property TimeSecThree = 9 Auto
{ how many times this is struck before giving a resource } 

int Property TimeSec Auto hidden 

int Property TimeSecOne = 5 Auto 

Int Property TimeSecCurrent = 0 Auto 

Float Property SecForFatigue Auto 

int Property PlayerFatigueProcentOne = 50 Auto 

Int Property PlayerFatigueProcentTwo = 75 Auto 

Int Property NeedSecForGiveOre = 5 Auto 

bool property ProcessStrikes = false Auto hidden
{Current number of attack strikes MOD}

SkyMp_OreFurnitureScript property myFurniture auto hidden
{ the furniture for this piece of ore, set in script }

objectReference property objSelf auto hidden
{ objectReference to self }

AchievementsScript property AchievementsQuest auto

Actor ActorSelf

string youTired = "Вы устали! Вам необходимо отдохнуть"

;===================================================================
;;EVENT BLOCK
;===================================================================
Event OnInit(); when this script is initialized
	TimeSec = TimeSecOne
EndEvent

Event OnUpdate()
	if ActorSelf
		
		FullnessOreCountHeal()

		ResetObj()
		
		DamageFullnessOreCountOrStopAnimation()

		EndMine()

		StopAnimationIfDiggingIsStop()

	endif
	
	
endEvent

event onCellAttach()
	if (ActorSelf)	

		blockActivation()
		SetNoFavorAllowed()
		objSelf = self as objectReference
		if !getLinkedRef()
			if (FullnessOreCount <= 0) 
			depleteOreDueToFailure()
			endif

		endif
	endif
endEvent

event onActivate(objectReference akActivator)
	ActorSelf = akActivator As Actor

	;Actor is attempting to mine
	if (akActivator as actor && myFurniture.isRegisteredForEvents == false && (ActorSelf as aaMP_PlayerFatigue).getFatigue() < 100)

		;if this is not depleted and the player has the right item 
		If (FullnessOreCount == 0)
			DepletedMessage.Show()
		elseif (playerHasTools() == false)
			FailureMessage.Show()
		;enter the furniture
		else
			if (getLinkedRef())
				; ActorSelf.ForceActorValue("StaminaRate", -100);
				ProcessStrikes = true
				RegisterForSingleUpdate(1.5)
				myFurniture = getLinkedRef() as SkyMp_OreFurnitureScript
				myFurniture.lastActivateRef = objSelf
				getLinkedRef().activate(akActivator)
				AchievementsQuest.incHardworker(2)
			Else
			endif
		endif
	
	elseif ((ActorSelf as aaMP_PlayerFatigue).getFatigue() >= 100)
		Debug.Notification(youTired)
	endif
	
endEvent

Function ResetObj()
	if (FullnessOreCount > 0 && FullnessOreCount < OreHealCount + 1)	
		self.Reset()
		self.clearDestruction()
		self.setDestroyed(False)
	endif
endFunction

;===================================================================
;;FUNCTION BLOCK
;===================================================================
bool function playerHasTools()
	if (ActorSelf)
		if ActorSelf.GetItemCount(mineOreToolsList) > 0
	; 		debug.Trace(self + ": playerHasTools is returning true")
			return true
		Else
	; 		debug.Trace(self + ": playerHasTools is returning false")
			return false
		endIf

	endif
endFunction

Function DamageFullnessOreCountOrStopAnimation()
	if ((ActorSelf as aaMP_PlayerFatigue).getFatigue() < (ActorSelf as aaMP_PlayerFatigue).getFatigueHigherLimit() && ProcessStrikes == true)
		(ActorSelf as aaMP_PlayerFatigue).modFatigue(modFatiguePerSec)
		TimeSecCurrent += 1

		FullnessOreCount -= DamageFullnessOreCountPerSec
		RegisterForSingleUpdate(1.0)

	elseif ((ActorSelf as aaMP_PlayerFatigue).getFatigue() >= 100 && ProcessStrikes == true)
		myFurniture.SetPlayerIsLeavingFurniture(true)
		myFurniture.isRegisteredForEvents = false
		myFurniture.goToState("reseting")
		
		TimeSecCurrent = 0
		ProcessStrikes = false
		UnregisterForUpdate()
	endif	
EndFunction

Function FullnessOreCountHeal()
	if (FullnessOreCount < 1000 && myFurniture.GetPlayerIsLeavingFurniture() == true)
		myFurniture.isRegisteredForEvents = false
		FullnessOreCount += OreHealCount
		RegisterForSingleUpdate(1.0)
	endif
EndFunction

Function EndMine()
	if (TimeSecCurrent >= NeedSecForGiveOre && ActorSelf.getAnimationVariableBool("bAnimationDriven") == true && (ActorSelf as aaMP_PlayerFatigue).getFatigue() > 0)
		
		myFurniture.SetPlayerIsLeavingFurniture(true)
		myFurniture.isRegisteredForEvents = false
		myFurniture.goToState("reseting")
		TimeSecCurrent = 0
		ProcessStrikes = false
		UnregisterForUpdate()
		; (ActorSelf as aaMP_PlayerFatigue).modFatigue(modFatiguePerSec)
		proccessAndStrikes(ActorSelf)
	endif
EndFunction

Function StopAnimationIfDiggingIsStop()
	if (ActorSelf.getAnimationVariableBool("bAnimationDriven") == false)
		ActorSelf.ModActorValue("StaminaRate", 100)
		myFurniture.isRegisteredForEvents = false
		myFurniture.goToState("reseting")
		ProcessStrikes == false
		UnregisterForUpdate()
	endif
EndFunction

function DebuffForOre()
	if (FullnessOreCount > 800) 
		TimeSec = TimeSecOne
	EndIf
	
	if (FullnessOreCount <= 800 && FullnessOreCount > 200) 
		TimeSec = TimeSecTwo
	EndIf

	if (FullnessOreCount <= 200 && FullnessOreCount > 0) 
		TimeSec = TimeSecThree
	EndIf
endfunction

function DebuffForPlayerMine()
	if ((ActorSelf as aaMP_PlayerFatigue).getFatigue() >= 0 && (ActorSelf as aaMP_PlayerFatigue).getFatigue() < 50)
		SecForFatigue = 0
	endif
	
	if ((ActorSelf as aaMP_PlayerFatigue).getFatigue() >= 50 && (ActorSelf as aaMP_PlayerFatigue).getFatigue() < 75)
		SecForFatigue = (NeedSecForGiveOre as Float)/100*PlayerFatigueProcentTwo
	endif
	
	if ((ActorSelf as aaMP_PlayerFatigue).getFatigue() >= 75 && (ActorSelf as aaMP_PlayerFatigue).getFatigue() <= 100)
		SecForFatigue = (NeedSecForGiveOre as Float)/100*PlayerFatigueProcentOne
	endif
endfunction

function proccessAndStrikes(objectReference akActivator)
	DebuffForOre()

	DebuffForPlayerMine()

	NeedSecForGiveOre = TimeSec + Math.Ceiling(SecForFatigue)

	giveOre(akActivator)
	
endFunction

function giveOre(objectReference akActivator)
	if ActorSelf
		
		if (FullnessOreCount > 0)
			if (FullnessOreCount == 0)
				self.damageObject(50)
				getLinkedRef().activate(objSelf)
				oreTakeSound.play(self)
				self.setDestroyed(true)
				; if this vein has ore and/or gems defined, give them.
				if ore
					akActivator.addItem(Ore, ResourceCount)
				endif
				if lItemGems10
					akActivator.addItem(lItemGems10)
				endif
				DepletedMessage.Show()
			else
				oreTakeSound.play(self)
				; if this vein has ore and/or gems defined, give them.
				if ore
					akActivator.addItem(Ore, ResourceCount)
				endif
				if lItemGems10
					akActivator.addItem(lItemGems10)
				endif
			endif
			
		elseif (FullnessOreCount <= 0)
			getLinkedRef().activate(objSelf)
			(getLinkedRef() as SkyMp_OreFurnitureScript).goToDepletedState()
			DepletedMessage.Show()
		endif
	endif

EndFunction

function depleteOreDueToFailure()
	self.damageObject(50)
	;THIS WASN'T WORKING RIGHT
	self.setDestroyed(true)
	FullnessOreCount = 0
endFunction

; ----------------- Getters ------------------------

