Scriptname MineDoorScript extends ObjectReference  

MineJobScript property MineJob auto

ObjectReference property TeleportMarker auto

Actor Property ActorSelf Auto

event onActivate(objectReference akActionRef)
    MineJob.DeleteJob(akActionRef)
    
    SetOpen(false)
    
    akActionRef.MoveTo(TeleportMarker)

    ActorSelf = akActionRef As Actor

    ActorSelf.ForceActorValue("StaminaRate", ActorSelf.GetBaseActorValue("StaminaRate"))

endevent