#include <sourcemod>
#include <colorlib>
#include <geoip>

#pragma newdecls required

ConVar g_CVConnectMsg;
ConVar g_CVDisconnectMsg;
ConVar g_CVAdminConnect;
ConVar g_CVAdminDisconnect;

public Plugin myinfo = 
{
	name = "Connect Announcer",
	author = "sneaK",
	description = "Basic (Dis)connect Announcer",
	version = "1.0",
	url = "snksrv.com"
};

public void OnPluginStart()
{
	LoadTranslations("connectannouncer.phrases");

	g_CVConnectMsg = CreateConVar("sm_cannouncer_connect_enable", "1", "Enable/Disable connect messages", _, true, 0.0, true, 1.0);
	g_CVDisconnectMsg = CreateConVar("sm_cannouncer_disconnect_enable", "2", "Enable disconnect messages for admins only - 2, Enable disconnect messages for everyone - 1, Disable disconnect messages - 0", _, true, 0.0, true, 2.0);
	g_CVAdminConnect = CreateConVar("sm_cannouncer_admin_connect", "0", "Show message of an admin connecting - 1, Suppress message - 0", _, true, 0.0, true, 1.0);
	g_CVAdminDisconnect = CreateConVar("sm_cannouncer_admin_disconnect", "0", "Show message of an admin disconnecting - 1, Suppress message - 0", _, true, 0.0, true, 1.0);

	HookEvent("player_disconnect", Event_ClientDisconnect, EventHookMode_Pre);

	AutoExecConfig(true, "cannouncer");
}

public Action Event_ClientDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	SetEventBroadcast(event, true);
	
	if (g_CVDisconnectMsg.IntValue == 0)
	{
		return Plugin_Handled;
	}
	
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if (!g_CVAdminDisconnect.BoolValue && CheckCommandAccess(client, "sm_cannouncer_admin", ADMFLAG_BAN))
	{
		return Plugin_Handled;
	}
	
	if (client >= 1)
	{
		char sReason[256], szName[MAX_NAME_LENGTH], steamid[32];
		GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
		GetEventString(event, "reason", sReason, sizeof(sReason));
		GetClientName(client, szName, sizeof(szName));
		
		if (g_CVDisconnectMsg.IntValue == 2)
		{
			CPrintToChatAdmins(ADMFLAG_GENERIC, "%t", "PlayerDisconnect", szName, steamid, sReason);
		}
		else if (g_CVDisconnectMsg.IntValue == 1)
		{
			CPrintToChatAll("%t", "PlayerDisconnect", szName, steamid, sReason);
		}
	}

	return Plugin_Continue;
}

public void OnClientPostAdminCheck(int client)
{
	if (!g_CVConnectMsg.BoolValue || IsFakeClient(client))
	{
		return;
	}

	char steamid[32], ip[64], country_name[45];
	GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid));
	GetClientIP(client, ip, sizeof(ip));
	GeoipCountry(ip, country_name, sizeof(country_name));

	if ((!g_CVAdminConnect.BoolValue) && CheckCommandAccess(client, "sm_cannouncer_admin", ADMFLAG_BAN))
	{
		CPrintToChatAdmins(ADMFLAG_GENERIC, "%t", "AdminConnect", client, steamid, country_name);
	}
	else if ((!g_CVAdminConnect.BoolValue) && CheckCommandAccess(client, "sm_cannouncer_moderator", ADMFLAG_GENERIC))
	{
		CPrintToChatAdmins(ADMFLAG_GENERIC, "%t", "ModeratorConnect", client, steamid, country_name);
	}

	if (!CheckCommandAccess(client, "sm_cannouncer_moderator", ADMFLAG_GENERIC))
	{
		CPrintToChatAll("%t", "PlayerConnect", client, steamid, country_name);
	}
}
