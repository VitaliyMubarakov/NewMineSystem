Scriptname MineContainerScript extends ObjectReference  

MineJobScript property MineJob auto

event OnInit() 
    self.BlockActivation(true)
endevent

event onActivate(objectReference akActionRef)
    MineJob.PayForWork(akActionRef)
endevent

