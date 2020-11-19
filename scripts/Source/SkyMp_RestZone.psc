Scriptname SkyMp_RestZone extends ObjectReference  

float Property StaminaRegenPerSec = 0.16 Auto

Actor ActorSelf

; -- GetSet ----------------
float Function GetStaminaRegenPerSec()
    return StaminaRegenPerSec
EndFunction

Function SetStaminaRegenPerSec(float ValueStaminaRegenPerSec)
    StaminaRegenPerSec = ValueStaminaRegenPerSec
EndFunction

; -- Events ---

Event OnUpdate()
    
    string stVal = "Stamina" 

    if (ActorSelf && ActorSelf.GetActorValue(stVal) < ActorSelf.GetBaseActorValue(stVal))
        ActorSelf.RestoreActorValue(stVal, StaminaRegenPerSec)
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
