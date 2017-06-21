
// This value should be true on the later versions of Source which uses client-predicted weapon switching
bool g_bPredictedWeaponSwitch = false;

// This value should be true on games where CBaseCombatWeapon derives from CEconEntity
bool g_bEconomyWeapons = false;

// This value should be true if view model offsets doesn't differ between different weapons (In this case only CS:GO)
bool g_bViewModelOffsetIndependent = false;

EngineVersion g_iEngineVersion;

char g_szViewModelClassName[CLASS_NAME_MAX_LENGTH] = "predicted_viewmodel";
char g_szWeaponPrefix[CLASS_NAME_MAX_LENGTH] = "weapon_";

int  g_Cl_ViewModels[MAXPLAYERS + 1][2];
int  g_Cl_LastSequence[MAXPLAYERS + 1];
int  g_Cl_CustomWeapon[MAXPLAYERS + 1];
int  g_Cl_DrawSequence[MAXPLAYERS + 1];
int  g_Cl_WeaponIndex[MAXPLAYERS + 1];
bool g_Cl_ToggleSequence[MAXPLAYERS + 1];
int  g_Cl_LastSequenceParity[MAXPLAYERS + 1];
int  g_Cl_SwapWeapon[MAXPLAYERS + 1];

int 	g_Weapon_DefIndex[MAX_CUSTOM_WEAPONS];
int 	g_Weapon_SwapWeapon[MAX_CUSTOM_WEAPONS]; // This property is used when g_bEconomyWeapons is false
int 	g_Weapon_SwapSequences[MAX_CUSTOM_WEAPONS][MAX_SEQEUENCES];
int 	g_Weapon_SequenceCount[MAX_CUSTOM_WEAPONS];
Handle  g_Weapon_Forward[MAX_CUSTOM_WEAPONS];
char    g_Weapon_ClassName[MAX_CUSTOM_WEAPONS][CLASS_NAME_MAX_LENGTH + 1];
char    g_Weapon_ViewModel[MAX_CUSTOM_WEAPONS][PLATFORM_MAX_PATH + 1];
char    g_Weapon_WorldModel[MAX_CUSTOM_WEAPONS][PLATFORM_MAX_PATH + 1];
//char 	g_Weapon_ArmsModel[PLATFORM_MAX_PATH + 1];
int 	g_Weapon_VMIndex[MAX_CUSTOM_WEAPONS];
int 	g_Weapon_WorldModelIndex[MAX_CUSTOM_WEAPONS];
int 	g_Weapon_TeamNum[MAX_CUSTOM_WEAPONS];
bool    g_Weapon_BlockLAW[MAX_CUSTOM_WEAPONS];
int 	g_Weapon_Status[MAX_CUSTOM_WEAPONS];

