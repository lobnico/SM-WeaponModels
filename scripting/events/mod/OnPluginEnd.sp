

//TODO: restore weapon model name
public void OnPluginEnd()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && g_Cl_CustomWeapon[i])
		{
			int viewModel1 = EntRefToEntIndex(g_Cl_ViewModels[i][0]);
			int viewModel2 = EntRefToEntIndex(g_Cl_ViewModels[i][1]);

			if (viewModel1 != -1)
			{
				SetEntityVisibility(viewModel1, true);
				SDKCall(g_hSDKCall_Entity_UpdateTransmitState, viewModel1);
			}

			if (viewModel2 != -1)
			{
				SetEntityVisibility(viewModel2, false);
				SDKCall(g_hSDKCall_Entity_UpdateTransmitState, viewModel2);
			}
		}
	}

	if (!g_bEconomyWeapons)
	{
		for (int i = 0; i < MAX_CUSTOM_WEAPONS; i++)
		{
			if (g_Weapon_Status[i] != STATUS_FREE)
			{
				CleanUpSwapWeapon(i);
			}
		}
	}
}