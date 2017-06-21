
public Action OnWeaponSwitch(int client, int weapon)
{
	int viewModel1 = EntRefToEntIndex(g_Cl_ViewModels[client][0]);
	int viewModel2 = EntRefToEntIndex(g_Cl_ViewModels[client][1]);

	if (viewModel1 == -1 || viewModel2 == -1)
	{
		return Plugin_Continue;
	}

	char className[CLASS_NAME_MAX_LENGTH];
	if (!GetEdictClassname(weapon, className, sizeof(className)))
	{
		return Plugin_Continue;
	}

	for (int i = 0; i < MAX_CUSTOM_WEAPONS; i++)
	{
		// Skip unused indexes
		if (g_Weapon_Status[i] == STATUS_FREE)
		{
			continue;
		}

		if (g_Weapon_DefIndex[i] != -1)
		{
			if (!g_bEconomyWeapons)
			{
				LogError("Game does not support item definition index! (Weapon index %i)", i + 1);

				continue;
			}

			int itemDefIndex = GetEntData(weapon, g_iOffset_EconItemDefinitionIndex);

			if (g_Weapon_DefIndex[i] != itemDefIndex)
			{
				continue;
			}

			if (g_Weapon_Forward[i] && !ExecuteForward(i, client, weapon, className, itemDefIndex))
			{
				continue;
			}
		}
		else if (!StrEqual(className, g_Weapon_ClassName[i], false))
		{
			continue;
		}
		else if (g_Weapon_Forward[i])
		{
			if (!ExecuteForward(i, client, weapon, className))
			{
				continue;
			}
		}
		else if (g_Weapon_TeamNum[i] && g_Weapon_TeamNum[i] != GetClientTeam(client))
		{
			continue;
		}

		g_Cl_SwapWeapon[client] = -1;
		g_Cl_CustomWeapon[client] = weapon;
		g_Cl_WeaponIndex[client] = i;

		// Get the class-name if the custom weapon is set by definition index
		if (g_Weapon_ClassName[i][0] == '\0')
		{
			GetEdictClassname(weapon, g_Weapon_ClassName[i], CLASS_NAME_MAX_LENGTH);
		}

		if (!g_bEconomyWeapons && EntRefToEntIndex(g_Weapon_SwapWeapon[i]) <= 0)
		{
			g_Weapon_SwapWeapon[i] = EntIndexToEntRef(CreateSwapWeapon(i, client));
		}

		return Plugin_Continue;
	}

	// Client has swapped to a regular weapon
	if (g_Cl_CustomWeapon[client] != 0)
	{
		g_Cl_CustomWeapon[client] = 0;
		g_Cl_WeaponIndex[client] = -1;
	}

	return Plugin_Continue;
}