#include <a_samp>

public OnFilterScriptInit()
{
    print("[DOCK RP] Accounts module loaded");
    return 1;
}

public OnPlayerConnect(playerid)
{
    SendClientMessage(
        playerid,
        0x00C8FFFF,
        "DOCK RP: Welcome!"
    );

    return 1;
}
