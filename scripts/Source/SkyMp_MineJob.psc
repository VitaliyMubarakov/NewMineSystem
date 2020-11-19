Scriptname SkyMp_MineJob extends ObjectReference  

;-- ˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜ --------------------------------------

formlist property needJobItems auto

;-- ˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜ --------------------------------------

; weapon property weapPickaxe auto
; armor property mineCloth auto
; armor property mineBoots auto

;-- ˜˜˜˜˜˜˜˜˜˜ ˜˜˜ --------------------------------------

formlist property Products auto

;-- ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ --------------------------------------
miscobject property Gold001 auto

;-- ˜˜˜˜˜˜ ˜˜˜ ˜˜ ˜˜˜˜ --------------------------------------
Int[] property ProductPrices auto

;-- ˜˜˜˜˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜˜ --------------------------------------
ObjectReference property ContainerForOre auto

;-- ˜˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜ --------------------------------------
miscobject property FakeItemForWork auto

Faction property PlayerIsMiner auto

;-- ˜˜˜˜ ˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜ --------------------------------------
sound property soundOfLeaveMineJob auto

Actor ActorSelf

; -- GetSet ----------------
Faction Function GetPlayerIsMiner()
    return PlayerIsMiner
EndFunction 

miscobject Function GetFakeItemForWork()
    return FakeItemForWork
EndFunction 

function PayForWork(ObjectReference ActorPay)

    Int i = 0
    
	while (i < Products.GetSize())
		ActorPay.AddItem(Gold001 as form, ActorPay.GetItemCount(Products.GetAt(i)) * ProductPrices[i], false)
		ActorPay.RemoveItem(Products.GetAt(i), ActorPay.GetItemCount(Products.GetAt(i)), false, ContainerForOre)
		i += 1
    endWhile
    
endFunction

Function DeleteJob(objectReference akActionRef)

    int i = 0

    self.PayForWork(akActionRef)

    While (i < needJobItems.GetSize()) 
        if (akActionRef.GetItemCount(needJobItems.GetAt(i)) >= 1)
            akActionRef.RemoveItem(needJobItems.GetAt(i) as form, 1, false)
        endif
        i += 1
    endWhile
    ; akActionRef.RemoveItem(FakeItemForWork as form, akActionRef.GetItemCount(FakeItemForWork as form), true, none)

    ActorSelf.RemoveFromFaction(PlayerIsMiner)
    
    Debug.MessageBox("Âû çàêîí÷èëè ñâîé ðàáî÷èé äåíü")

EndFunction

Function SetJob(objectReference akActionRef)

    int i = 0
    
    While (i < needJobItems.GetSize())       
        if (akActionRef.GetItemCount(needJobItems.GetAt(i)) == 0)
            
            akActionRef.AddItem(needJobItems.GetAt(i) as form, 1, false)
        endif
        i += 1
    endWhile
    ; akActionRef.AddItem(FakeItemForWork as form, 1, true)

    ActorSelf.AddToFaction(PlayerIsMiner)

    Debug.MessageBox("Âû íà÷àëè ñâîé ðàáî÷èé äåíü")

EndFunction

Event onActivate(objectReference akActionRef)

    ActorSelf = akActionRef As Actor

    if (ActorSelf.IsInFaction(PlayerIsMiner) == false)
        SetJob(akActionRef)
    else
        DeleteJob(akActionRef)
        soundOfLeaveMineJob.Play(akActionRef)
    endif

endEvent