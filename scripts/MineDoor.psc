Scriptname MineDoor extends ObjectReference  

MineJobScript property MineJob auto

ObjectReference property TeleportMarker auto

Actor Property ActorSelf Auto

Event onActivate(objectReference akActionRef)

    MineJob.DeleteJob(akActionRef)   
    SetOpen(false)
    
    akActionRef.MoveTo(TeleportMarker)
    ActorSelf = akActionRef As Actor

    string StRate = "StaminaRate"
    ActorSelf.ForceActorValue(StRate, ActorSelf.GetBaseActorValue(StRate))

endEvent