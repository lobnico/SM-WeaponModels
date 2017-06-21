
public void OnConfigsExecuted()
{
	// In case of map-change
	for (int i = 0; i < MAX_CUSTOM_WEAPONS; i++)
	{
		if (g_Weapon_Status[i] == STATUS_API)
		{
			PrecacheWeaponInfo(i);
		}
	}

	LoadConfig();
}