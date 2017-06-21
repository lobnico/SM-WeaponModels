
public void OnClientSpawnPost(int client)
{
	// No spectators
	if (GetClientTeam(client) < 2)
	{
		return;
	}

	g_Cl_CustomWeapon[client] = 0;

	int viewModel1 = GetPlayerViewModel(client, 0);
	int viewModel2 = GetPlayerViewModel(client, 1);

	// If a secondary view model doesn't exist, create one
	if (viewModel2 == -1)
	{
		if ((viewModel2 = CreateEntityByName(g_szViewModelClassName)) == -1)
		{
			LogError("Failed to create secondary view model!");

			return;
		}

		SetEntDataEnt2(viewModel2, g_iOffset_ViewModelOwner, client, true);
		SetEntData(viewModel2, g_iOffset_ViewModelIndex, 1, _, true);
		
		if (g_iOffset_ViewModelIgnoreOffsAcc != -1)
		{
			SetEntData(viewModel2, g_iOffset_ViewModelIgnoreOffsAcc, true, 1, true);
		}
		
		DispatchSpawn(viewModel2);

		SetPlayerViewModel(client, 1, viewModel2);
	}

	g_Cl_ViewModels[client][0] = EntIndexToEntRef(viewModel1);
	g_Cl_ViewModels[client][1] = EntIndexToEntRef(viewModel2);

	// Hide the secondary view model, in case the player has respawned
	SetEntityVisibility(viewModel2, false);

	int activeWeapon = GetEntDataEnt2(client, g_iOffset_PlayerActiveWeapon);

	OnWeaponSwitch(client, activeWeapon);
	OnWeaponSwitchPost(client, activeWeapon);
}