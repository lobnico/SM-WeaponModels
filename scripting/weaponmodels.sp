/**
 * =============================================================================
 * Custom Weapon Models
 *
 * Copyright (C) 2015 Andersso
 * =============================================================================
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

// TODO:
// Test L4D1/L4D2
// Toggle animation seems to bug on some rare occasions
// Proxy over m_nSkin to view model 2? (sleeve skin)
// Add support for non-custom weapon models
/*
	this should be tested when parsing config!
	
	sm_weaponmodels_reloadconfig needs fixing!
	
	
	Fix dropped weapon models!
	
	Add activity translate feature thingy!
*/



#include "modIncludes.sp"
#include "modDefines.sp"

#include "weaponmodels/entitydata.sp"
#include "modIncludes.sp"



#include "modGlobals.sp"

#include "config/config.sp"
#include "weaponmodels/csgo.sp"
#include "weaponmodels/api.sp"

#include "events/mod/AskPluginLoad2.sp"


#include "events/mod/OnPluginStart.sp"

#include "events/client/Event_PlayerDeath.sp"

#include "events/mod/OnPluginEnd.sp"
#include "events/mod/OnConfigsExecuted.sp"


#include "events/client/OnPostAdminCheck.sp"
#include "events/client/OnSpawnPost.sp"
#include "events/client/OnWeaponSwitch.sp"
#include "events/client/OnWeaponSwitchPost.sp"
#include "events/client/OnPostThinkPost.sp"

#include "lib/tools.sp"
#include "lib/buildSwapSequenceArray.sp"


void PrecacheWeaponInfo(int weaponIndex)
{
	g_Weapon_VMIndex[weaponIndex] = PrecacheWeaponInfo_PrecacheModel(g_Weapon_ViewModel[weaponIndex]);
	g_Weapon_WorldModelIndex[weaponIndex] = PrecacheWeaponInfo_PrecacheModel(g_Weapon_WorldModel[weaponIndex]);
}

int PrecacheWeaponInfo_PrecacheModel(const char[] model)
{
	return model[0] != '\0' ? PrecacheModel(model, true) : 0;
}

void CleanUpSwapWeapon(int weaponIndex)
{
	int swapWeapon = EntRefToEntIndex(g_Weapon_SwapWeapon[weaponIndex]);

	if (swapWeapon > 0)
	{
		AcceptEntityInput(swapWeapon, "Kill");
	}
}

int CreateSwapWeapon(int weaponIndex, int client)
{
	int customWeapon = g_Cl_CustomWeapon[client];
	
	if (g_bViewModelOffsetIndependent)
	{
		for (int i = 0; i < MAX_WEAPONS; i++)
		{
			int weapon = GetEntDataEnt2(client, g_iOffset_CharacterWeapons + (i * 4));
			
			if (weapon != -1 && weapon != customWeapon)
			{
				return weapon;
			}
		}
	}
	
	int swapWeapon = CreateEntityByName(g_Weapon_ClassName[weaponIndex]);

	if (swapWeapon == -1)
	{
		return LogError("Failed to create swap weapon entity!");
	}
	
	DispatchSpawn(swapWeapon);

	SetEntDataEnt2(swapWeapon, g_iOffset_WeaponOwner, client, true);
	SetEntDataEnt2(swapWeapon, g_iOffset_EntityOwnerEntity, client, true);

	SetEntityMoveType(swapWeapon, MOVETYPE_NONE);

	// CEconEntity: The parent of the swap weapon must the client using it
	SetVariantString("!activator");
	AcceptEntityInput(swapWeapon, "SetParent", client);

	return swapWeapon;
}


void ToggleViewModelWeapon(int client, int viewModel, int weaponIndex)
{
	int swapWeapon;

	if ((g_Cl_ToggleSequence[client] = !g_Cl_ToggleSequence[client]))
	{
		swapWeapon = EntRefToEntIndex(g_bEconomyWeapons ? g_Cl_SwapWeapon[client] : g_Weapon_SwapWeapon[weaponIndex]);

		if (swapWeapon == -1)
		{
			swapWeapon = CreateSwapWeapon(weaponIndex, client);

			if (g_bEconomyWeapons)
			{
				g_Cl_SwapWeapon[client] = EntIndexToEntRef(swapWeapon);
			}
			else
			{
				g_Weapon_SwapWeapon[weaponIndex] = EntIndexToEntRef(swapWeapon);
			}
		}
	}
	else
	{
		swapWeapon = g_Cl_CustomWeapon[client];
	}

	SetEntDataEnt2(viewModel, g_iOffset_ViewModelWeapon, swapWeapon, true);
}
