Scriptname NewMine extends ObjectReference  

sound property DrScOreOpen auto
{sound played when Ore is acquired}

formlist property mineOreToolsList auto
{Optional: Player must have at least one item from this formlist to interact}

Message Property FailureMessage Auto  
{Message to say why you can't use this without RequiredWeapon}

Message Property DepletedMessage Auto  
{Message to say that this vein is depleted}

MiscObject Property Ore Auto  
{what you get from this Ore Vein}

LeveledItem property lItemGems10 auto
{Optional: Gems that may be mined along with ore}

int Property ResourceCount = 1 Auto
{how many resources you get per drop}

int Property FullnessOreCount = 1000 Auto 
{fullness MOD}

int Property OreHealCount = 1 Auto 
{fullness MOD}

int Property ProcessMinus = 6 Auto 
{fullness MOD}

int property StrikesNeed = 12 Auto
{how many times this is struck before giving a resource} 

int property StrikesNeedTwo = 30 Auto
{how many times this is struck before giving a resource} 

int property StrikesNeedThree = 40 Auto
{how many times this is struck before giving a resource} 

int property StrikesCurrent = 0 Auto hidden
{Current number of strikes}

bool property ProcessStrikes = false Auto hidden
{Current number of attack strikes MOD}

int Property TimeSec = 15 Auto 

Int Property TimeSecCurrent = 0 Auto 

mineOreFurnitureScript property myFurniture auto hidden
{the furniture for this piece of ore, set in script}

objectReference property objSelf auto hidden
{objectReference to self}

AchievementsScript property AchievementsQuest auto

Actor Property ActorSelf Auto


;===================================================================
;;EVENT BLOCK
;===================================================================
; Event OnInit(); when this script is initialized
; 	RegisterForUpdate(1.0);register for an onupdate event in 5 seconds
; 	; RegisterForUpdateGameTime(0.5)
; EndEvent

Event OnUpdate()
	if ActorSelf
	
		if FullnessOreCount < 1000	
			FullnessOreCount += OreHealCount
			RegisterForSingleUpdate(1.0)
		endif

		if FullnessOreCount > 0 && FullnessOreCount < OreHealCount + 1
			ResetObj()
		endif
		
		if ActorSelf.GetActorValue("Stamina") > 0 && ProcessStrikes == true
			ActorSelf.DamageActorValue("Stamina", 2.0)
			TimeSecCurrent += 1
			RegisterForSingleUpdate(1.0)
		
		elseif ActorSelf.GetActorValue("Stamina") <= 0 && ProcessStrikes == true
			myFurniture.playerIsLeavingFurniture = True
			myFurniture.goToState("reseting")
			
			TimeSecCurrent = 0
			ProcessStrikes = false
			UnregisterForUpdate()
		endif	

		

		if TimeSecCurrent == TimeSec && ActorSelf.getAnimationVariableBool("bAnimationDriven") == true
			myFurniture.playerIsLeavingFurniture = True
			myFurniture.goToState("reseting")
			
			TimeSecCurrent = 0
			ProcessStrikes = false
			UnregisterForUpdate()

			proccessStrikes(ActorSelf)
		endif

		if ActorSelf.getAnimationVariableBool("bAnimationDriven") == false
			ActorSelf.ModActorValue("StaminaRate", 100)
			ProcessStrikes == false
			UnregisterForUpdate()
		endif

	endif
	
	
endEvent

event onCellAttach()
	if ActorSelf	

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
	if akActivator as actor
		;if this is not depleted and the player has the right item 
		If FullnessOreCount == 0
			DepletedMessage.Show()
		elseif playerHasTools() == false
			FailureMessage.Show()
		;enter the furniture
		else
			if getLinkedRef()
				ActorSelf.ForceActorValue("StaminaRate", -100);
				ProcessStrikes = true
				RegisterForSingleUpdate(1.5)
				myFurniture = getLinkedRef() as mineOreFurnitureScript
				myFurniture.lastActivateRef = objSelf
				getLinkedRef().activate(akActivator)
				AchievementsQuest.incHardworker(2)
			Else
			endif
		endif
	endif
endEvent

Function ResetObj()
	self.Reset()
	self.clearDestruction()
	self.setDestroyed(False)
endFunction

;===================================================================
;;FUNCTION BLOCK
;===================================================================
bool function playerHasTools()
	if ActorSelf
		if ActorSelf.GetItemCount(mineOreToolsList) > 0
	; 		debug.Trace(self + ": playerHasTools is returning true")
			return true
		Else
	; 		debug.Trace(self + ": playerHasTools is returning false")
			return false
		endIf

	endif
endFunction

function proccessStrikes(objectReference akActivator)
	if (FullnessOreCount <= 800 && FullnessOreCount > 200) 
		StrikesNeed = StrikesNeedTwo
	EndIf

	if (FullnessOreCount <= 200 && FullnessOreCount > 0) 
		StrikesNeed = StrikesNeedThree
	EndIf

	if FullnessOreCount >= ProcessMinus
		FullnessOreCount -= ProcessMinus
		giveOre(akActivator)
	endif
	
endFunction

function giveOre(objectReference akActivator)
	if ActorSelf
		
		if FullnessOreCount > 0
			if FullnessOreCount == 0
				self.damageObject(50)
				getLinkedRef().activate(objSelf)
				DrScOreOpen.play(self)
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
				DrScOreOpen.play(self)
				; if this vein has ore and/or gems defined, give them.
				if ore
					akActivator.addItem(Ore, ResourceCount)
				endif
				if lItemGems10
					akActivator.addItem(lItemGems10)
				endif
			endif
			
		elseif FullnessOreCount <= 0
			getLinkedRef().activate(objSelf)
			(getLinkedRef() as MineOreFurnitureScript).goToDepletedState()
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
