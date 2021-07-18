// TMF AutoSplitter
// Made by donadigo

state("TmForever")
{
    int playground            : 0x1580, -808, 0x454;
    int playerInfosBufferSize : 0x1580, -808, 0x12C, 0x2FC;
    int currentPlayerInfo     : 0x1580, -808, 0x12C, 0x300, 0x0;
    int raceTime              : 0x1580, -808, 0x12C, 0x300, 0x0, 0x2B0;
    int raceState             : 0x1580, -808, 0x12C, 0x300, 0x0, 292;
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
    if (current.playground == 0 || 
        current.playerInfosBufferSize == 0 ||
        current.currentPlayerInfo == 0 ||
        (current.raceState & 0x200) == 0) {
        return false;
    }

    if (old.raceTime < 0 && current.raceTime >= 0) {
        vars.currentRunTime = current.raceTime;
        return true;
    }

    return false;
}

isLoading
{
    return true;
}

gameTime
{
    if (current.playground == 0 || 
        current.playerInfosBufferSize == 0 ||
        current.currentPlayerInfo == 0 ||
        (current.raceState & 0x200) == 0) {
        return System.TimeSpan.FromMilliseconds(vars.currentRunTime);
    }

    if (current.raceTime >= 0) {
        int oldRaceTime = Math.Max (old.raceTime, 0);
        int newRaceTime = Math.Max (current.raceTime, 0);
        vars.currentRunTime += (newRaceTime - oldRaceTime);
    }

    return System.TimeSpan.FromMilliseconds(vars.currentRunTime);
}

split
{
    if (current.playground == 0 || current.playerInfosBufferSize == 0 || current.currentPlayerInfo == 0) {
        return false;
    }

    return (old.raceState & 0x400) == 0 && (current.raceState & 0x400) != 0;
}