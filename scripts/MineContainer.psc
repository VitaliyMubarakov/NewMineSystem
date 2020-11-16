Scriptname MineContainer extends ObjectReference  

MineJobScript property MineJob auto

Event OnInit() 
    self.BlockActivation(true)
endEvent

Event onActivate(objectReference akActionRef)
    MineJob.PayForWork(akActionRef)
endEvent

