-- Autogenerated lua file by the Spyface tool
-- 'Wimps and posers -- leave the hall! -- ManOwaR
--
-- DO NOT HAND EDIT.
--
local tiles =
{
    {
        x = 2,
        y = 1,
        variant = 0,
        impass = 1,
        cover = 1,
    },
    {
        x = 3,
        y = 1,
        variant = 0,
    },
    {
        x = 2,
        y = 2,
        variant = 1,
        impass = 1,
        cover = 1,
    },
    {
        x = 3,
        y = 2,
        variant = 1,
    },
    {
        x = 2,
        y = 3,
        variant = 1,
    },
    {
        x = 3,
        y = 3,
        variant = 1,
    },
    {
        x = 1,
        y = 1,
        variant = 0,
        impass = 1,
        cover = 1,
    },
    {
        x = 1,
        y = 2,
        variant = 0,
        impass = 1,
        cover = 1,
    },
    {
        x = 1,
        y = 3,
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
        x = 2,
        y = 4,
        variant = 0,
    },
    {
        x = 4,
        y = 1,
        variant = 0,
    },
    {
        x = 4,
        y = 2,
        variant = 1,
        impass = 1,
        cover = 1,
    },
    {
        x = 4,
        y = 3,
        variant = 1,
        impass = 1,
        cover = 1,
    },
    {
        x = 4,
        y = 4,
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
        variant = 1,
        impass = 1,
        cover = 1,
    },
    {
        x = 5,
        y = 3,
        variant = 1,
        impass = 1,
        cover = 1,
    },
    {
        x = 5,
        y = 4,
        variant = 0,
    },
}
local walls =
{
}
local units =
{
}
local decos =
{
    {
        x = 2,
        y = 2,
        kanim = [[decor_engineroom_2x2_biggear1]],
        facing = 2,
    },
    {
        x = 4,
        y = 3,
        kanim = [[decor_engineroom_2x1_gear1]],
        facing = 4,
    },
    {
        x = 5,
        y = 3,
        kanim = [[decor_engineroom_2x1_gear6]],
        facing = 4,
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
                id0 = 1,
                x0 = 3,
                y0 = 1,
                id1 = 100,
                x1 = 2,
                y1 = 1,
            },
            {
                id0 = 2,
                x0 = 2,
                y0 = 0,
                id1 = 100,
                x1 = 2,
                y1 = 1,
            },
            {
                id0 = 1,
                x0 = 2,
                y0 = 3,
                id1 = 100,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 1,
                x0 = 3,
                y0 = 2,
                id1 = 100,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 3,
                x0 = 1,
                y0 = 0,
                id1 = 100,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 4,
                x0 = 0,
                y0 = 1,
                id1 = 100,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 1,
                x0 = 1,
                y0 = 3,
                id1 = 100,
                x1 = 1,
                y1 = 2,
            },
            {
                id0 = 5,
                x0 = 0,
                y0 = 2,
                id1 = 100,
                x1 = 1,
                y1 = 2,
            },
            {
                id0 = 1,
                x0 = 4,
                y0 = 1,
                id1 = 106,
                x1 = 4,
                y1 = 2,
            },
            {
                id0 = 1,
                x0 = 3,
                y0 = 2,
                id1 = 106,
                x1 = 4,
                y1 = 2,
            },
            {
                id0 = 1,
                x0 = 4,
                y0 = 4,
                id1 = 106,
                x1 = 4,
                y1 = 3,
            },
            {
                id0 = 1,
                x0 = 3,
                y0 = 3,
                id1 = 106,
                x1 = 4,
                y1 = 3,
            },
            {
                id0 = 7,
                x0 = 6,
                y0 = 2,
                id1 = 106,
                x1 = 5,
                y1 = 2,
            },
            {
                id0 = 1,
                x0 = 5,
                y0 = 1,
                id1 = 106,
                x1 = 5,
                y1 = 2,
            },
            {
                id0 = 1,
                x0 = 5,
                y0 = 4,
                id1 = 106,
                x1 = 5,
                y1 = 3,
            },
            {
                id0 = 8,
                x0 = 6,
                y0 = 3,
                id1 = 106,
                x1 = 5,
                y1 = 3,
            },
        },
    },
    width = 5,
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
