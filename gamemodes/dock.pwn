
#include <a_samp>

#define DIALOG_REGISTER 1000
#define DIALOG_LOGIN 1001

new DB:gDatabase;

main() {}

public OnGameModeInit()
{
    SetGameModeText("DOCK RP | Classic RP");
    SetWorldTime(12);
    SetWeather(10);

    gDatabase = db_open("dock.db");

    if (gDatabase == DB:0)
    {
        print("DOCK RP: DATABASE ERROR!");
        return 1;
    }

    db_free_result(db_query(gDatabase,
        "CREATE TABLE IF NOT EXISTS accounts (\
        id INTEGER PRIMARY KEY AUTOINCREMENT,\
        username TEXT UNIQUE NOT NULL,\
        password_hash TEXT NOT NULL,\
        money INTEGER DEFAULT 5000,\
        bank INTEGER DEFAULT 0,\
        level INTEGER DEFAULT 1,\
        faction INTEGER DEFAULT 0,\
        rank INTEGER DEFAULT 0)"));

    print("DOCK RP STARTED!");
    return 1;
}

public OnGameModeExit()
{
    if (gDatabase != DB:0)
        db_close(gDatabase);

    return 1;
}

public OnPlayerConnect(playerid)
{
    new name[MAX_PLAYER_NAME];
    new query[128];

    GetPlayerName(playerid, name, sizeof(name));

    format(query, sizeof(query),
        "SELECT id FROM accounts WHERE username='%q'", name);

    new DBResult:result = db_query(gDatabase, query);

    if (db_num_rows(result))
    {
        ShowPlayerDialog(playerid, DIALOG_LOGIN,
            DIALOG_STYLE_PASSWORD,
            "DOCK RP | Авторизация",
            "Введите пароль от своего аккаунта:",
            "Войти", "Выход");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER,
            DIALOG_STYLE_PASSWORD,
            "DOCK RP | Регистрация",
            "Придумайте пароль для нового аккаунта:",
            "Создать", "Выход");
    }

    db_free_result(result);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response,
    listitem, inputtext[])
{
    if (!response)
    {
        Kick(playerid);
        return 1;
    }

    new name[MAX_PLAYER_NAME];
    new hash[65];
    new query[256];

    GetPlayerName(playerid, name, sizeof(name));

    if (dialogid == DIALOG_REGISTER)
    {
        if (strlen(inputtext) < 6 || strlen(inputtext) > 32)
        {
            ShowPlayerDialog(playerid, DIALOG_REGISTER,
                DIALOG_STYLE_PASSWORD,
                "DOCK RP | Регистрация",
                "Пароль должен содержать от 6 до 32 символов.",
                "Создать", "Выход");
            return 1;
        }

        SHA256_PassHash(inputtext, name, hash, sizeof(hash));

        format(query, sizeof(query),
            "INSERT INTO accounts (username, password_hash) VALUES ('%q','%q')",
            name, hash);

        db_free_result(db_query(gDatabase, query));

        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, 5000);

        SendClientMessage(playerid, 0x00C8FFFF,
            "Добро пожаловать на DOCK RP! Аккаунт создан.");

        return 1;
    }

    if (dialogid == DIALOG_LOGIN)
    {
        SHA256_PassHash(inputtext, name, hash, sizeof(hash));

        format(query, sizeof(query),
            "SELECT id FROM accounts WHERE username='%q' AND password_hash='%q'",
            name, hash);

        new DBResult:result = db_query(gDatabase, query);

        if (db_num_rows(result))
        {
            SendClientMessage(playerid, 0x00FF00FF,
                "Вы успешно авторизовались на DOCK RP!");
        }
        else
        {
            SendClientMessage(playerid, 0xFF0000FF,
                "Неверный пароль. Попробуйте снова.");

            ShowPlayerDialog(playerid, DIALOG_LOGIN,
                DIALOG_STYLE_PASSWORD,
                "DOCK RP | Авторизация",
                "Неверный пароль. Введите его ещё раз:",
                "Войти", "Выход");
        }

        db_free_result(result);
        return 1;
    }

    return 0;
}
