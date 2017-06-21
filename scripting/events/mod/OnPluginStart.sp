
public void OnPluginStart()
{
	CreateConVar("sm_weaponmodels_version", PLUGIN_VERSION, PLUGIN_NAME, FCVAR_NOTIFY|FCVAR_DONTRECORD);

	WeaponModels_ConfigInit();
	
	switch (g_iEngineVersion = GetEngineVersion())
	{
		case Engine_DODS:
		{
			g_szViewModelClassName = "dod_viewmodel";
		}
		case Engine_TF2:
		{
			g_szViewModelClassName = "tf_viewmodel";
			g_szWeaponPrefix = "tf_weapon_";
		}
		case Engine_Left4Dead, Engine_Left4Dead2, Engine_Portal2:
		{
			g_bPredictedWeaponSwitch = true;
		}
		case Engine_CSGO:
		{
			g_bPredictedWeaponSwitch = true;
			g_bViewModelOffsetIndependent = true;
			
			WeaponModels_CSGOInit();
		}
	}

	WeaponModels_EntityDataInit();
	
	g_bEconomyWeapons = g_iOffset_EconItemDefinitionIndex != -1;
	
	HookEvent("player_death", Event_PlayerDeath);
}
