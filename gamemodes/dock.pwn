#include <a_samp>

main() {}

public OnGameModeInit()

{

    SetGameModeText("DOCK RP | Classic RP");

    SetWorldTime(12);

    SetWeather(10);

    print("DOCK RP STARTED!");

    return 1;

}

public OnPlayerConnect(playerid)

{

    SendClientMessage(playerid, -1,

        "Dobro pozhalovat na DOCK RP!");

    return 1;

}
