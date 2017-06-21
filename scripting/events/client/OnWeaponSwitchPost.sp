
public void OnWeaponSwitchPost(int client, int weapon)
{
	// Callback is sometimes called on disconnected clients
	if (!IsClientConnected(client))
	{
		return;
	}

	int viewModel1 = EntRefToEntIndex(g_Cl_ViewModels[client][0]);
	int viewModel2 = EntRefToEntIndex(g_Cl_ViewModels[client][1]);

	if (viewModel1 == -1 || viewModel2 == -1)
	{
		return;
	}

	int weaponIndex = g_Cl_WeaponIndex[client];

	if (weapon != g_Cl_CustomWeapon[client])
	{
		// Hide the secondary view model. This needs to be done on post because the weapon needs to be switched first
		if (weaponIndex == -1)
		{
			SetEntityVisibility(viewModel1, true);
			SDKCall(g_hSDKCall_Entity_UpdateTransmitState, viewModel1);

			SetEntityVisibility(viewModel2, false);
			SDKCall(g_hSDKCall_Entity_UpdateTransmitState, viewModel2);

			g_Cl_WeaponIndex[client] = 0;
		}

		return;
	}

	if (g_Weapon_VMIndex[weaponIndex])
	{
		SetEntityVisibility(viewModel1, false);
		SetEntityVisibility(viewModel2, true);
		
		if (g_iEngineVersion == Engine_CSGO)
		{
			StopParticleEffects(client, viewModel2);
		}

		if (g_bPredictedWeaponSwitch)
		{
			g_Cl_DrawSequence[client] = GetEntData(viewModel1, g_iOffset_ViewModelSequence);

			// Switch to an invalid sequence to prevent it from playing sounds before UpdateTransmitStateTime() is called
			SetEntData(viewModel1, g_iOffset_ViewModelSequence, -1, _, true);
		}
		else
		{
			SetEntData(viewModel2, g_iOffset_ViewModelSequence, GetEntData(viewModel1, g_iOffset_ViewModelSequence), _, true);

			SDKCall(g_hSDKCall_Entity_UpdateTransmitState, viewModel1);
		}

		SDKCall(g_hSDKCall_Entity_UpdateTransmitState, viewModel2);

		SetEntityModel(weapon, g_Weapon_ViewModel[weaponIndex]);

		if (g_Weapon_SequenceCount[weaponIndex] == -1)
		{
			int sequenceCount = Animating_GetSequenceCount(weapon);

			if (sequenceCount > 0)
			{
				int swapSequences[MAX_SEQEUENCES];

				if (sequenceCount < MAX_SEQEUENCES)
				{

					BuildSwapSequenceArray(swapSequences, sequenceCount, weapon);

					g_Weapon_SequenceCount[weaponIndex] = sequenceCount;
					g_Weapon_SwapSequences[weaponIndex] = swapSequences;
				}
				else
				{
					LogError("View model \"%s\" is having too many sequences! (Max %i, is %i) - Increase value of MAX_SEQEUENCES in plugin",
						g_Weapon_ViewModel[weaponIndex],
						MAX_SEQEUENCES,
						sequenceCount);
				}
			}
			else
			{
				for (int i = 0; i < MAX_SEQEUENCES; i++)
				{
					g_Weapon_SwapSequences[weaponIndex][i] = -1;
				}

				LogError("Failed to get sequence count for weapon using model \"%s\" - Animations may not work as expected",
					g_Weapon_ViewModel[weaponIndex]);
			}
		}

		SetEntData(viewModel1, g_iOffset_EntityModelIndex, g_Weapon_VMIndex[weaponIndex], _, true);
		SetEntData(viewModel2, g_iOffset_EntityModelIndex, g_Weapon_VMIndex[weaponIndex], _, true);
		
		SetEntDataFloat(viewModel2, g_iOffset_ViewModelPlaybackRate, GetEntDataFloat(viewModel1, g_iOffset_ViewModelPlaybackRate), true);

		// FIXME: Why am I calling this?
		ToggleViewModelWeapon(client, viewModel2, weaponIndex);
		
		g_Cl_LastSequenceParity[client] = -1;
	}
	else
	{
		g_Cl_CustomWeapon[client] = 0;
	}

	if (g_Weapon_WorldModelIndex[weaponIndex])
	{
		SetEntData(weapon, g_iOffset_WeaponWorldModelIndex, g_Weapon_WorldModelIndex[weaponIndex], _, true);
	}
}