Scriptname ZoneOfRelaxTrigScript extends ObjectReference  

float Property StaminaRegenPerSec = 0.16 Auto

Actor Property ActorSelf Auto

Event OnUpdate()
    if ActorSelf && ActorSelf.GetActorValue("Stamina") < ActorSelf.GetBaseActorValue("Stamina")
        ActorSelf.RestoreActorValue("Stamina", StaminaRegenPerSec)
        RegisterForSingleUpdate(1.0)
    endif
endEvent

Event OnTriggerEnter(ObjectReference akTriggerRef)
    ActorSelf = akTriggerRef As Actor    
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnTriggerLeave(ObjectReference akTriggerRef)
        UnregisterForUpdate()
EndEvent
