
public void OnClientPostThinkPost(int client)
{
	// Callback is sometimes called on disconnected clients
	if (!IsClientConnected(client))
	{
		return;
	}

	if (g_Cl_CustomWeapon[client] == 0)
	{
		return;
	}

	int viewModel1 = EntRefToEntIndex(g_Cl_ViewModels[client][0]);
	int viewModel2 = EntRefToEntIndex(g_Cl_ViewModels[client][1]);

	if (viewModel1 == -1 || viewModel2 == -1)
	{
		return;
	}

	int sequence = GetEntData(viewModel1, g_iOffset_ViewModelSequence);

	int drawSequence = -1;
	
	if (g_bPredictedWeaponSwitch)
	{
		drawSequence = g_Cl_DrawSequence[client];
		
		if (sequence == -1)
		{
			sequence = drawSequence;
		}
	}
	
	static int newSequenceParityOffset = 0;

	if (!newSequenceParityOffset)
	{
		InitDataMapOffset(newSequenceParityOffset, viewModel1, "m_nNewSequenceParity");
	}

	int sequenceParity = GetEntData(viewModel1, newSequenceParityOffset);

	// Sequence has not changed since last think
	if (sequence == g_Cl_LastSequence[client])
	{
		// Skip on weapon switch
		if (g_Cl_LastSequenceParity[client] != -1)
		{
			// Skip if sequence hasn't finished
			if (sequenceParity == g_Cl_LastSequenceParity[client])
			{
				return;
			}

			int weaponIndex = g_Cl_WeaponIndex[client];
			int swapSequence = g_Weapon_SwapSequences[weaponIndex][sequence];
			
			// Change to swap sequence, if present
			if (swapSequence != -1)
			{
				//SetEntData(viewModel1, g_iOffset_ViewModelSequence, swapSequence, _, true);
				//SetEntData(viewModel2, g_iOffset_ViewModelSequence, swapSequence, _, true);

				//g_Cl_LastSequence[client] = swapSequence;
			}
			else
			{
				ToggleViewModelWeapon(client, viewModel2, weaponIndex);
			}
		}
	}
	else
	{
		if (g_bPredictedWeaponSwitch && drawSequence != -1 && sequence != drawSequence)
		{
			SDKCall(g_hSDKCall_Entity_UpdateTransmitState, viewModel1);

			g_Cl_DrawSequence[client] = -1;
		}
		
		SetEntData(viewModel2, g_iOffset_ViewModelSequence, sequence, _, true);

		g_Cl_LastSequence[client] = sequence;
	}
	
	g_Cl_LastSequenceParity[client] = sequenceParity;
}
