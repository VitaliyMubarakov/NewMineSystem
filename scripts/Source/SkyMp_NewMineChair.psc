Scriptname SkyMp_NewMineChair extends ObjectReference  

float Property FatigueChairRegenPerSec Auto

SkyMp_RestZone property RestZone auto

bool isSeat = false

Actor ActorSelf

float Property GetStaminaRegenPerSec Auto

Event OnUpdate()   

    if (self.IsFurnitureMarkerInUse(0) == false)
        ; RestZone.SetStaminaRegenPerSec(GetStaminaRegenPerSec - FatigueChairRegenPerSec)
        RestZone.SetFatigueRegenPerSec(RestZone.GetFatigueRegenPerSec() - FatigueChairRegenPerSec)
        Debug.MessageBox(RestZone.GetFatigueRegenPerSec())
        isSeat = !isSeat
        UnregisterForUpdate()
    endif

endEvent

Event onActivate(objectReference akActionRef)
    if (isSeat == false)
        isSeat = !isSeat
        FatigueChairRegenPerSec = RestZone.GetFatigueRegenPerSec()/100 * 200
        GetStaminaRegenPerSec = RestZone.GetFatigueRegenPerSec()
        ; RestZone.SetStaminaRegenPerSec(GetStaminaRegenPerSec + FatigueChairRegenPerSec)
        RestZone.SetFatigueRegenPerSec(RestZone.GetFatigueRegenPerSec() + FatigueChairRegenPerSec)
        RegisterForUpdate(1.0)
    endif
    
endEvent