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
        impass = 1,
        cover = 1,
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
        impass = 1,
        cover = 1,
    },
    {
        x = 1,
        y = 2,
        variant = 0,
        tags =
        {
            "letter_spawn",
        },
        impass = 1,
        cover = 1,
    },
    {
        x = 1,
        y = 3,
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
    {
        x = 1,
        y = 3,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 0,
        y = 3,
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
        y = 2,
        kanim = [[ftm_lab_stool2]],
        facing = 0,
    },
    {
        x = 1,
        y = 1,
        kanim = [[ftm_lab_blackboard2]],
        facing = 0,
    },
    {
        x = 1,
        y = 2,
        kanim = [[ftm_lab_coats]],
        facing = 0,
    },
    {
        x = 1,
        y = 1,
        kanim = [[decor_ftm_lab_flooring_1x1alt2]],
        facing = 0,
    },
    {
        x = 2,
        y = 1,
        kanim = [[decor_ftm_lab_flooring_1x1alt2]],
        facing = 6,
    },
    {
        x = 3,
        y = 1,
        kanim = [[ftm_lab_console2]],
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
                y0 = 2,
                id1 = 101,
                x1 = 3,
                y1 = 1,
            },
            {
                id0 = 2,
                x0 = 4,
                y0 = 1,
                id1 = 101,
                x1 = 3,
                y1 = 1,
            },
            {
                id0 = 3,
                x0 = 3,
                y0 = 0,
                id1 = 101,
                x1 = 3,
                y1 = 1,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 1,
                id1 = 101,
                x1 = 3,
                y1 = 1,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 1,
                id1 = 104,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 5,
                x0 = 1,
                y0 = 0,
                id1 = 104,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 6,
                x0 = 0,
                y0 = 1,
                id1 = 104,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 0,
                x0 = 1,
                y0 = 3,
                id1 = 104,
                x1 = 1,
                y1 = 2,
            },
            {
                id0 = 0,
                x0 = 2,
                y0 = 2,
                id1 = 104,
                x1 = 1,
                y1 = 2,
            },
            {
                id0 = 7,
                x0 = 0,
                y0 = 2,
                id1 = 104,
                x1 = 1,
                y1 = 2,
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
