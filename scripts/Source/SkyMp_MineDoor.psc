Scriptname SkyMp_MineDoor extends ObjectReference  

SkyMp_MineJob property MineJob auto

ObjectReference property TeleportMarker auto

Actor ActorSelf

Event onActivate(objectReference akActionRef)

    MineJob.DeleteJob(akActionRef)   
    SetOpen(false)
    
    akActionRef.MoveTo(TeleportMarker)
    ActorSelf = akActionRef As Actor

    string StRate = "StaminaRate"
    ActorSelf.ForceActorValue(StRate, ActorSelf.GetBaseActorValue(StRate))

endEvent