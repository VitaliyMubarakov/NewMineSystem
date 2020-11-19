Scriptname SkyMp_NewMineChair extends ObjectReference  

float Property StaminaChairRegenPerSec = 0.6 Auto

SkyMp_RestZone property RestZone auto

bool isSeat = false

Actor ActorSelf

float Property GetStaminaRegenPerSec Auto

Event OnUpdate()   

    if (self.IsFurnitureMarkerInUse(0) == false)
        UnregisterForUpdate()
        ; RestZone.SetStaminaRegenPerSec(GetStaminaRegenPerSec - StaminaChairRegenPerSec)
        RestZone.StaminaRegenPerSec -= StaminaChairRegenPerSec
        isSeat = !isSeat
    endif

endEvent

Event onActivate(objectReference akActionRef)
    
    if (isSeat == false)
        isSeat = !isSeat
        RegisterForUpdate(1.0)
        GetStaminaRegenPerSec = RestZone.GetStaminaRegenPerSec()
        ; RestZone.SetStaminaRegenPerSec(GetStaminaRegenPerSec + StaminaChairRegenPerSec)
        RestZone.StaminaRegenPerSec += StaminaChairRegenPerSec
    endif
    
endEvent