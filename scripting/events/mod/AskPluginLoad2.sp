
public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	WeaponModels_ApiInit();

	if (late)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				OnClientPostAdminCheck(i);
			}
		}
	}
	
	return APLRes_Success;
}
