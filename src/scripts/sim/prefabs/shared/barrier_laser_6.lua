-- Autogenerated lua file by the Spyface tool
-- 'Wimps and posers -- leave the hall! -- ManOwaR
--
-- DO NOT HAND EDIT.
--
local tiles =
{
    {
        x = 3,
        y = 1,
        variant = 1,
    },
    {
        x = 3,
        y = 2,
        variant = 1,
    },
    {
        x = 4,
        y = 1,
        variant = 0,
    },
    {
        x = 4,
        y = 2,
        variant = 0,
    },
    {
        x = 2,
        y = 2,
        variant = 0,
    },
    {
        x = 2,
        y = 1,
        variant = 0,
    },
    {
        x = 5,
        y = 1,
        variant = 0,
    },
    {
        x = 5,
        y = 2,
        variant = 0,
    },
    {
        x = 1,
        y = 1,
        variant = 0,
    },
    {
        x = 1,
        y = 2,
        variant = 0,
    },
}
local walls =
{
    {
        x = 3,
        y = 0,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 3,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 3,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 3,
        y = 3,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 4,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 4,
        y = 3,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 5,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 5,
        y = 3,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 6,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 5,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 6,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 5,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 2,
        y = 0,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 2,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 6,
    },
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
    {
        x = 1,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 0,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 1,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 0,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 0,
    },
}
local units =
{
    {
        maxCount = 1,
        spawnChance = 1,
        {
            {
                x = 3,
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
            {
                id0 = 0,
                x0 = 3,
                y0 = 0,
                id1 = 1,
                x1 = 3,
                y1 = 1,
            },
            {
                id0 = 1,
                x0 = 3,
                y0 = 2,
                id1 = 2,
                x1 = 3,
                y1 = 3,
            },
            {
                id0 = 1,
                x0 = 4,
                y0 = 2,
                id1 = 3,
                x1 = 4,
                y1 = 3,
            },
            {
                id0 = 1,
                x0 = 5,
                y0 = 2,
                id1 = 4,
                x1 = 5,
                y1 = 3,
            },
            {
                id0 = 5,
                x0 = 6,
                y0 = 1,
                id1 = 1,
                x1 = 5,
                y1 = 1,
            },
            {
                id0 = 6,
                x0 = 6,
                y0 = 2,
                id1 = 1,
                x1 = 5,
                y1 = 2,
            },
            {
                id0 = 7,
                x0 = 2,
                y0 = 0,
                id1 = 1,
                x1 = 2,
                y1 = 1,
            },
            {
                id0 = 8,
                x0 = 1,
                y0 = 0,
                id1 = 1,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 1,
                x0 = 1,
                y0 = 1,
                id1 = 9,
                x1 = 0,
                y1 = 1,
            },
            {
                id0 = 1,
                x0 = 1,
                y0 = 2,
                id1 = 10,
                x1 = 0,
                y1 = 2,
            },
        },
    },
    width = 5,
    height = 2,
    version = 1,
    tiles = tiles,
    walls = walls,
    units = units,
    decos = decos,
    lights = lights,
    sounds = sounds,
}
return export
