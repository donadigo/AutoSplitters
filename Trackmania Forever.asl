// TMF AutoSplitter
// Made by donadigo

state("TmForever", "Nations")
{
    int playerInfoClass : 0x009560CC, 0x0, 0x1C, 0x0;
    int raceTime : 0x009560CC, 0x0, 0x1C, 0x2B0;
    bool raceFinished : 0x009560CC, 0x0, 0x1C, 0x33C;
}

state("TmForever", "United")
{
    int playerInfoClass : 0x0095772C, 0x0, 0x1C, 0x0;
    int raceTime : 0x0095772C, 0x0, 0x1C, 0x2B0;
    bool raceFinished : 0x0095772C, 0x0, 0x1C, 0x33C;
}

update
{
    return true;
}

init
{
    if (memory.ReadValue<byte>((System.IntPtr)0x00401076) == 0x70) {
        version = "United";
        vars.targetInfoClass = 0x00B41FBC;
    } else {
        version = "Nations";
        vars.targetInfoClass = 0x00B41FC4;
    }

    vars.currentRunTime = 0;
}

start
{
    vars.currentRunTime = 0;
    return current.playerInfoClass == vars.targetInfoClass;
}

isLoading
{
    return true;
}

gameTime
{
    if (current.playerInfoClass == vars.targetInfoClass &&
        current.raceTime >= 0 &&
        current.raceTime > old.raceTime) {
        int oldRaceTime = Math.Max (old.raceTime, 0);
        int newRaceTime = Math.Max (current.raceTime, 0);
        vars.currentRunTime += (newRaceTime - oldRaceTime);
    }

    return System.TimeSpan.FromMilliseconds(vars.currentRunTime);
}

split
{
    if (current.playerInfoClass != vars.targetInfoClass) {
        return false;
    }

    return current.raceFinished && !old.raceFinished;
}