-- Autogenerated lua file by the Spyface tool
-- 'Wimps and posers -- leave the hall! -- ManOwaR
--
-- DO NOT HAND EDIT.
--
local tiles =
{
    {
        x = 4,
        y = 4,
        variant = 0,
    },
    {
        x = 3,
        y = 4,
        variant = 0,
        impass = 1,
        cover = 1,
    },
    {
        x = 2,
        y = 4,
        variant = 0,
        impass = 1,
        cover = 1,
    },
    {
        x = 2,
        y = 5,
        variant = 0,
    },
    {
        x = 3,
        y = 5,
        variant = 0,
    },
    {
        x = 4,
        y = 5,
        variant = 0,
    },
    {
        x = 2,
        y = 3,
        variant = 0,
    },
    {
        x = 3,
        y = 3,
        variant = 0,
    },
    {
        x = 4,
        y = 3,
        variant = 0,
    },
    {
        x = 2,
        y = 2,
        variant = 0,
        impass = 1,
        cover = 1,
    },
    {
        x = 3,
        y = 2,
        variant = 0,
        impass = 1,
        cover = 1,
    },
    {
        x = 4,
        y = 2,
        variant = 0,
    },
    {
        x = 2,
        y = 1,
        variant = 0,
    },
    {
        x = 3,
        y = 1,
        variant = 0,
    },
    {
        x = 4,
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
        x = 1,
        y = 5,
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
        x = 3,
        y = 2,
        kanim = [[decor_finalhall_2x1_bench1]],
        facing = 2,
    },
    {
        x = 3,
        y = 2,
        kanim = [[decor_finalhall_2x1_floorpanel1]],
        facing = 2,
    },
    {
        x = 3,
        y = 4,
        kanim = [[decor_finalhall_2x1_floorpanel1]],
        facing = 2,
    },
    {
        x = 3,
        y = 4,
        kanim = [[decor_finalhall_2x1_bench1]],
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
                x0 = 3,
                y0 = 5,
                id1 = 101,
                x1 = 3,
                y1 = 4,
            },
            {
                id0 = 0,
                x0 = 4,
                y0 = 4,
                id1 = 101,
                x1 = 3,
                y1 = 4,
            },
            {
                id0 = 0,
                x0 = 3,
                y0 = 3,
                id1 = 101,
                x1 = 3,
                y1 = 4,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 5,
                id1 = 101,
                x1 = 2,
                y1 = 4,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 3,
                id1 = 101,
                x1 = 2,
                y1 = 4,
            },
            {
                id0 = 0,
                x0 = 1,
                y0 = 4,
                id1 = 101,
                x1 = 2,
                y1 = 4,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 3,
                id1 = 102,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 1,
                id1 = 102,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 1,
                y0 = 2,
                id1 = 102,
                x1 = 2,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 3,
                y0 = 3,
                id1 = 102,
                x1 = 3,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 4,
                y0 = 2,
                id1 = 102,
                x1 = 3,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 3,
                y0 = 1,
                id1 = 102,
                x1 = 3,
                y1 = 2,
            },
        },
    },
    width = 4,
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
