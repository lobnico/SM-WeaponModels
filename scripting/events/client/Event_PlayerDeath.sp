

public void Event_PlayerDeath(Event event, const char[] eventName, bool dontBrodcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));

	// Event is sometimes called with client index 0 in Left 4 Dead
	if (client == 0)
	{
		return;
	}

	// Add compatibility with Zombie:Reloaded
	if (IsPlayerAlive(client))
	{
		return;
	}

	int viewModel2 = EntRefToEntIndex(g_Cl_ViewModels[client][1]);

	if (viewModel2 != -1)
	{
		// Hide the custom view model if the player dies
		SetEntityVisibility(viewModel2, false);
	}

	g_Cl_ViewModels[client] = { -1, -1 };
	g_Cl_CustomWeapon[client] = 0;
}