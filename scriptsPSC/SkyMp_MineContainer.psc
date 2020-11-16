Scriptname SkyMP_MineContainer extends ObjectReference  

SkyMp_MineJob property MineJob auto

Event OnInit() 
    self.BlockActivation(true)
endEvent

Event onActivate(objectReference akActionRef)
    MineJob.PayForWork(akActionRef)
endEvent

