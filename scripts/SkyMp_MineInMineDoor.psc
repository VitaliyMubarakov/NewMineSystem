Scriptname SkyMp_MineInMineDoor extends ObjectReference  

SkyMp_MineJob property MineJob auto

ObjectReference property TeleportMarker auto

Actor Property ActorSelf Auto


auto state waitingForActor

	Event onTriggerEnter(ObjectReference akTriggerRef)

		if akTriggerRef.GetItemCount(MineJob.FakeItemForWork as form) == 1
            akTriggerRef.MoveTo(TeleportMarker)

            ActorSelf = akTriggerRef As Actor

            ActorSelf.ForceActorValue("StaminaRate", -100)
            
        else
            Debug.MessageBox("�� �� ������ ���� ������! ��� ����� ���������� �� ������ � �����")
        endif

    endEvent
    
endState
