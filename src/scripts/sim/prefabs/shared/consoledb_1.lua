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
        variant = 0,
        dynamic_impass = 1,
    },
}
local walls =
{
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
                template = [[console_core]],
                unitData =
                {
                    facing = 0,
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
                x0 = 1,
                y0 = 2,
                id1 = 101,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 2,
                x0 = 2,
                y0 = 1,
                id1 = 101,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 3,
                x0 = 1,
                y0 = 0,
                id1 = 101,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 4,
                x0 = 0,
                y0 = 1,
                id1 = 101,
                x1 = 1,
                y1 = 1,
            },
        },
    },
    width = 1,
    height = 1,
    version = 1,
    tiles = tiles,
    walls = walls,
    units = units,
    decos = decos,
    lights = lights,
    sounds = sounds,
}
return export
