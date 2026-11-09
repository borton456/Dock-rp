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
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, 5000);

    SendClientMessage(
        playerid,
        0x00C8FFFF,
        "Добро пожаловать на DOCK RP!"
    );

    SendClientMessage(
        playerid,
        0x00FF00FF,
        "Ваш стартовый капитал: $5000"
    );

    return 1;
}


{

    SendClientMessage(playerid, -1,

        "Dobro pozhalovat na DOCK RP!");

    return 1;

}
