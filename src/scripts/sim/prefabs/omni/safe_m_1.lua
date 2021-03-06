-- Autogenerated lua file by the Spyface tool
-- 'Wimps and posers -- leave the hall! -- ManOwaR
--
-- DO NOT HAND EDIT.
--
local tiles =
{
    {
        x = 2,
        y = 2,
        zone = [[solid]],
        variant = 0,
        impass = 1,
    },
    {
        x = 2,
        y = 3,
        variant = 0,
        dynamic_impass = 1,
    },
    {
        x = 3,
        y = 2,
        variant = 0,
    },
    {
        x = 3,
        y = 3,
        variant = 0,
    },
    {
        x = 1,
        y = 3,
        variant = 0,
    },
    {
        x = 2,
        y = 4,
        variant = 0,
    },
    {
        x = 1,
        y = 4,
        variant = 0,
    },
    {
        x = 3,
        y = 4,
        variant = 0,
    },
    {
        x = 3,
        y = 1,
        variant = 0,
    },
    {
        x = 2,
        y = 1,
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
        y = 2,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 2,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 2,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 2,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 2,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 1,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 2,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 2,
        y = 3,
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
                x = 2,
                y = 3,
                template = [[lab_safe]],
                unitData =
                {
                    facing = 2,
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
                y0 = 2,
                id1 = 101,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 1,
                id1 = 101,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 101,
                x0 = 2,
                y0 = 2,
                id1 = 0,
                x1 = 1,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 3,
                y0 = 2,
                id1 = 101,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 1,
                id1 = 101,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 1,
                y0 = 2,
                id1 = 101,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 4,
                id1 = 101,
                x1 = 2,
                y1 = 3,
            },
            {
                id0 = 0,
                x0 = 3,
                y0 = 3,
                id1 = 101,
                x1 = 2,
                y1 = 3,
            },
            {
                id0 = 0,
                x0 = 1,
                y0 = 3,
                id1 = 101,
                x1 = 2,
                y1 = 3,
            },
        },
    },
    width = 3,
    height = 4,
    version = 1,
    tiles = tiles,
    walls = walls,
    units = units,
    decos = decos,
    lights = lights,
    sounds = sounds,
}
return export
