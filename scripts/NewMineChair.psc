Scriptname NewMineChair extends ObjectReference  

float Property StaminaChairRegenPerSec = 0.6 Auto

ZoneOfRelaxTrigScript property RelaxTrig auto

bool Property isSeat = false Auto

Actor Property ActorSelf Auto

event OnUpdate()   
    if self.IsFurnitureMarkerInUse(0) == false
        UnregisterForUpdate()
        RelaxTrig.StaminaRegenPerSec -= StaminaChairRegenPerSec
        isSeat = !isSeat
    Else
    endif
endevent

event onActivate(objectReference akActionRef)
    if isSeat == false
        isSeat = !isSeat
        RegisterForUpdate(1.0)
        RelaxTrig.StaminaRegenPerSec += StaminaChairRegenPerSec
    endif
endEvent