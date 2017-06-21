#pragma semicolon 1

#define PLUGIN_NAME "Custom Weapon Models"
#define PLUGIN_VERSION "1.2tf"


// This should be on top, sm includes still not updated as of today
#pragma newdecls required

Plugin myinfo =
{
	name        = PLUGIN_NAME,
	author      = "Mr L - original from Andersso",
	description = "Change any weapon model",
	version     = PLUGIN_VERSION,
	url         = "http://www.sourcemod.net/"
};
#define STATUS_FREE 0 
#define STATUS_CONFIG 1
#define STATUS_API 2

#define MAX_CUSTOM_WEAPONS 50

#define MAX_SEQEUENCES 256

#define CLASS_NAME_MAX_LENGTH 48

#define EF_NODRAW 0x20

#define PARTICLE_DISPATCH_FROM_ENTITY (1 << 0)

#define PATTACH_WORLDORIGIN 5

#define SWAP_SEQ_PAIRED (1 << 31)

#define MAX_WEAPONS 48