Scriptname SkyMp_NewMineChair extends ObjectReference  

float Property StaminaChairRegenPerSec = 0.6 Auto

SkyMp_ZoneOfRelaxTrig property RelaxTrig auto

bool Property isSeat = false Auto

Actor Property ActorSelf Auto

Event OnUpdate()   

    if self.IsFurnitureMarkerInUse(0) == false
        UnregisterForUpdate()
        RelaxTrig.StaminaRegenPerSec -= StaminaChairRegenPerSec
        isSeat = !isSeat
    endif

endEvent

Event onActivate(objectReference akActionRef)
    
    if isSeat == false
        isSeat = !isSeat
        RegisterForUpdate(1.0)
        RelaxTrig.StaminaRegenPerSec += StaminaChairRegenPerSec
    endif
    
endEvent