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
        impass = 1,
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
}
local units =
{
}
local decos =
{
    {
        x = 1,
        y = 1,
        kanim = [[decor_ko_office_lamp]],
        facing = 2,
    },
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
