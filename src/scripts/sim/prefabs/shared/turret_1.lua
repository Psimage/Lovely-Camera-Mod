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
        x = 2,
        y = 2,
        variant = 0,
    },
    {
        x = 3,
        y = 2,
        variant = 0,
    },
    {
        x = 2,
        y = 3,
        variant = 0,
    },
    {
        x = 1,
        y = 2,
        variant = 0,
        dynamic_impass = 1,
    },
    {
        x = 1,
        y = 3,
        variant = 0,
        dynamic_impass = 1,
    },
    {
        x = 3,
        y = 3,
        variant = 0,
    },
}
local walls =
{
}
local units =
{
    {
        maxCount = 2,
        spawnChance = 1,
        {
            {
                x = 1,
                y = 2,
                template = [[turret]],
                unitData =
                {
                    facing = 0, traits = { startOn = true },
                },
            },
            1,
        },
        {
            {
                x = 1,
                y = 3,
                template = [[turret_generator]],
                unitData =
                {
                    facing = 0, traits = { startOn = true },
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
                id0 = 1,
                x0 = 2,
                y0 = 2,
                id1 = 100,
                x1 = 1,
                y1 = 2,
            },
            {
                id0 = 1,
                x0 = 1,
                y0 = 1,
                id1 = 100,
                x1 = 1,
                y1 = 2,
            },
            {
                id0 = 2,
                x0 = 0,
                y0 = 2,
                id1 = 100,
                x1 = 1,
                y1 = 2,
            },
            {
                id0 = 3,
                x0 = 1,
                y0 = 4,
                id1 = 100,
                x1 = 1,
                y1 = 3,
            },
            {
                id0 = 1,
                x0 = 2,
                y0 = 3,
                id1 = 100,
                x1 = 1,
                y1 = 3,
            },
            {
                id0 = 4,
                x0 = 0,
                y0 = 3,
                id1 = 100,
                x1 = 1,
                y1 = 3,
            },
        },
    },
    width = 3,
    height = 3,
    version = 1,
    tiles = tiles,
    walls = walls,
    units = units,
    decos = decos,
    lights = lights,
    sounds = sounds,
}
return export
