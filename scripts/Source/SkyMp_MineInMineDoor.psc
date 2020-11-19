Scriptname SkyMp_MineInMineDoor extends ObjectReference  

SkyMp_MineJob property MineJob auto

ObjectReference property TeleportMarker auto

Actor ActorSelf


auto state waitingForActor

	Event onTriggerEnter(ObjectReference akTriggerRef)

        ActorSelf = akTriggerRef As Actor

		if (ActorSelf.IsInFaction(MineJob.PlayerIsMiner) == true)
            akTriggerRef.MoveTo(TeleportMarker)

            ActorSelf.ForceActorValue("StaminaRate", -100)

        else
            Debug.MessageBox("Вы не можете сюда пройти, устройтесь на работу шахтёром")
        endif

    endEvent
    
endState
