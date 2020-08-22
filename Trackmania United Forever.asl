// TMUF AutoSplitter
// Made by donadigo

state("TmForever")
{
    // int playerInfoAddress : 0x0095772C, 0x0, 0x1C;
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
    vars.currentRunTime = 0;
}

start
{
    vars.currentRunTime = 0;
    return current.playerInfoClass == 0x00B41FBC;
}

isLoading
{
    return true;
}

gameTime
{
    if (current.playerInfoClass == 0x00B41FBC &&
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
    if (current.playerInfoClass != 0x00B41FBC) {
        return false;
    }

    return current.raceFinished && !old.raceFinished;
}

// reset
// {
//     if (current.playerInfoClass != 0x00B41FBC) {
//         return false;
//     }

//     int mapNameLen = memory.ReadValue<int>((System.IntPtr)(current.playerInfoAddress + 0x3A8));
//     int mapNamePtr = memory.ReadValue<int>((System.IntPtr)current.playerInfoAddress + 0x3A8 + 0x4);
//     string mapName = "";
//     for (int i = 0; i < mapNameLen * 2; i += 2) {
//         mapName += (char)memory.ReadValue<byte>((System.IntPtr)(mapNamePtr + i));
//     }

//     print(mapName);
//     return false;
// }