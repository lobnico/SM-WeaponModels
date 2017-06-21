

public void OnClientPostAdminCheck(int client)
{
	g_Cl_ViewModels[client] = { -1, -1 };
	g_Cl_CustomWeapon[client] = 0;

	SDKHook(client, SDKHook_SpawnPost, OnClientSpawnPost);
	SDKHook(client, SDKHook_WeaponSwitch, OnWeaponSwitch);
	SDKHook(client, SDKHook_WeaponSwitchPost, OnWeaponSwitchPost);
	SDKHook(client, SDKHook_PostThinkPost, OnClientPostThinkPost);
}
