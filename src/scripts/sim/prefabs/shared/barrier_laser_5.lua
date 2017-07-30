-- Autogenerated lua file by the Spyface tool
-- 'Wimps and posers -- leave the hall! -- ManOwaR
--
-- DO NOT HAND EDIT.
--
local tiles =
{
    {
        x = 1,
        y = 1,
        variant = 1,
    },
    {
        x = 1,
        y = 2,
        variant = 1,
    },
    {
        x = 1,
        y = 3,
        variant = 1,
    },
    {
        x = 1,
        y = 4,
        variant = 1,
    },
    {
        x = 1,
        y = 5,
        variant = 1,
    },
    {
        x = 2,
        y = 1,
        variant = 0,
    },
    {
        x = 2,
        y = 2,
        variant = 0,
    },
    {
        x = 2,
        y = 3,
        variant = 0,
    },
    {
        x = 2,
        y = 4,
        variant = 0,
    },
    {
        x = 2,
        y = 5,
        variant = 0,
    },
}
local walls =
{
    {
        x = 1,
        y = 0,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 1,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 6,
    },
}
local units =
{
    {
        maxCount = 1,
        spawnChance = 1,
        {
            {
                x = 1,
                y = 1,
                template = [[security_laser_emitter_1x1]],
                unitData =
                {
                    facing = 2, traits = { startOn = true },
                },
            },
            1,
        },
    },
}
local decos =
{
}
local lights =
{
}
local sounds =
{
}
local export =
{
    cgraph =
    {
        edges =
        {
        },
    },
    width = 2,
    height = 5,
    version = 1,
    tiles = tiles,
    walls = walls,
    units = units,
    decos = decos,
    lights = lights,
    sounds = sounds,
}
return export