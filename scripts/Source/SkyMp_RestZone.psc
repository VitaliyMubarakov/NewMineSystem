Scriptname SkyMp_RestZone extends ObjectReference  

float Property FatigueRegenPerSec = 0.27 Auto

int PlayersCount
int PlayersCountProcent
int PlayersCountProcentMax = 30
int Property ProcentRegenForPlayer Auto

FormList Property ActorsInTrigger Auto

Actor ActorSelf

; ======== Getters ========
float Function GetFatigueRegenPerSec()
    return FatigueRegenPerSec
EndFunction

; ======== Setters ========
Function SetFatigueRegenPerSec(float ValueFatigueRegenPerSec)
    FatigueRegenPerSec = ValueFatigueRegenPerSec
EndFunction

; -- Events ---

Event OnUpdate()
    HealPlayerInRestZone()
endEvent

Event OnTriggerEnter(ObjectReference akTriggerRef)
    PlayerEnterRestZone(akTriggerRef)
EndEvent

Event OnTriggerLeave(ObjectReference akTriggerRef)
    PlayerLeaveRestZone(akTriggerRef)
EndEvent

; ------------------- Functions -------------------------

Function PlayerLeaveRestZone(ObjectReference akTriggerRef)
    PlayersCount -= 1
    
    int i = 0
    while (i < ActorsInTrigger.GetSize())
        (ActorsInTrigger.GetAt(i) as aaMP_PlayerFatigue).modFatigue(-FatigueRegenPerSec)
        
        if (ActorsInTrigger.GetAt(i) == akTriggerRef)
            ActorsInTrigger.RemoveAddedForm(ActorsInTrigger.GetAt(i))
        endif

        (ActorsInTrigger.GetAt(i) as aaMP_PlayerFatigue).setFatigueAccumulationAllow(true)
        
        i += 1
    endwhile

    if (PlayersCount <= 0)
        UnregisterForUpdate()
    endif
EndFunction

Function PlayerEnterRestZone(ObjectReference akTriggerRef)
    ActorsInTrigger.AddForm(akTriggerRef)
    int i = 0
    while (i < ActorsInTrigger.GetSize())
        (ActorsInTrigger.GetAt(i) as aaMP_PlayerFatigue).setFatigueAccumulationAllow(false)
        i += 1
    endwhile

    PlayersCount += 1
    if (PlayersCountProcent != PlayersCountProcentMax)
        PlayersCountProcent = PlayersCount * ProcentRegenForPlayer 
    endif
    
    ActorSelf = akTriggerRef As Actor    
    RegisterForSingleUpdate(1.0)
EndFunction

Function HealPlayerInRestZone()
    if (ActorSelf)
        if (PlayersCount > 1)
            FatigueRegenPerSec = FatigueRegenPerSec/100 * PlayersCountProcent
        endif
    
        int i = 0
        while (i < ActorsInTrigger.GetSize())
            (ActorsInTrigger.GetAt(i) as aaMP_PlayerFatigue).modFatigue(-FatigueRegenPerSec)
            i += 1
        endwhile
        
        RegisterForSingleUpdate(1.0)
    endif
EndFunction