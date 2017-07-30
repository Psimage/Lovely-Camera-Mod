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
        zone = [[solid]],
        variant = 0,
        impass = 1,
    },
    {
        x = 1,
        y = 2,
        zone = [[solid]],
        variant = 0,
        impass = 1,
    },
    {
        x = 1,
        y = 3,
        zone = [[elevator]],
        variant = 2,
        exitID = 1,
    },
    {
        x = 1,
        y = 4,
        zone = [[elevator]],
        variant = 0,
        exitID = 1,
    },
    {
        x = 1,
        y = 5,
        zone = [[solid]],
        variant = 0,
        impass = 1,
    },
    {
        x = 1,
        y = 6,
        zone = [[solid]],
        variant = 0,
        impass = 1,
    },
    {
        x = 2,
        y = 1,
        zone = [[solid]],
        variant = 0,
        impass = 1,
    },
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
        zone = [[elevator]],
        variant = 3,
        exitID = 1,
    },
    {
        x = 2,
        y = 4,
        zone = [[elevator]],
        variant = 1,
        exitID = 1,
    },
    {
        x = 2,
        y = 5,
        zone = [[solid]],
        variant = 0,
        impass = 1,
    },
    {
        x = 2,
        y = 6,
        zone = [[solid]],
        variant = 0,
        impass = 1,
    },
    {
        x = 3,
        y = 3,
        variant = 0,
        tags =
        {
            "door_front",
        },
    },
    {
        x = 3,
        y = 4,
        variant = 0,
        tags =
        {
            "door_front",
        },
    },
    {
        x = 4,
        y = 3,
        variant = 0,
    },
    {
        x = 4,
        y = 4,
        variant = 0,
    },
    {
        x = 4,
        y = 1,
        variant = 0,
    },
    {
        x = 3,
        y = 1,
        variant = 0,
    },
    {
        x = 3,
        y = 2,
        variant = 0,
    },
    {
        x = 4,
        y = 2,
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
        x = 4,
        y = 6,
        variant = 0,
    },
    {
        x = 3,
        y = 6,
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
        x = 5,
        y = 3,
        variant = 0,
    },
    {
        x = 5,
        y = 4,
        variant = 0,
    },
    {
        x = 5,
        y = 5,
        variant = 0,
    },
    {
        x = 5,
        y = 6,
        variant = 0,
    },
}
local walls =
{
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
    {
        x = 1,
        y = 4,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 0,
        y = 4,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 1,
        y = 5,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 0,
        y = 5,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 1,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 0,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 1,
        y = 2,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 1,
        y = 3,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 1,
        y = 4,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 1,
        y = 5,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 2,
        y = 4,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 2,
        y = 5,
        wallIndex = [[default_wall]],
        dir = 6,
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
        x = 3,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 2,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 3,
        y = 5,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 2,
        y = 5,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 3,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 2,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 1,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 1,
        y = 7,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 2,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 2,
        y = 7,
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
        x = 3,
        y = 3,
        wallIndex = [[elevator_alt]],
        dir = 4,
    },
    {
        x = 2,
        y = 3,
        wallIndex = [[elevator_alt]],
        dir = 0,
    },
    {
        x = 3,
        y = 4,
        wallIndex = [[elevator]],
        dir = 4,
    },
    {
        x = 2,
        y = 4,
        wallIndex = [[elevator]],
        dir = 0,
    },
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
        x = 4,
        y = 0,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 4,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 3,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 3,
        y = 7,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 4,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 4,
        y = 7,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 6,
        y = 5,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 5,
        y = 5,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 6,
        y = 4,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 5,
        y = 4,
        wallIndex = [[default_wall]],
        dir = 0,
    },
    {
        x = 6,
        y = 3,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 5,
        y = 3,
        wallIndex = [[default_wall]],
        dir = 0,
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
        x = 5,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 5,
        y = 7,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 5,
        y = 0,
        wallIndex = [[default_wall]],
        dir = 2,
    },
    {
        x = 5,
        y = 1,
        wallIndex = [[default_wall]],
        dir = 6,
    },
    {
        x = 6,
        y = 6,
        wallIndex = [[default_wall]],
        dir = 4,
    },
    {
        x = 5,
        y = 6,
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
        x = 3,
        y = 5,
        kanim = [[ftm_elevator_panel]],
        facing = 0,
    },
    {
        x = 3,
        y = 2,
        kanim = [[ftm_elevator_panel]],
        facing = 0,
    },
    {
        x = 1,
        y = 3,
        kanim = [[decor_elevator_arrows]],
        facing = 2,
    },
    {
        x = 2,
        y = 3,
        kanim = [[decor_elevator_arrows]],
        facing = 2,
    },
    {
        x = 1,
        y = 4,
        kanim = [[decor_elevator_arrows]],
        facing = 6,
    },
    {
        x = 2,
        y = 4,
        kanim = [[decor_elevator_arrows]],
        facing = 6,
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
                id0 = 100,
                x0 = 1,
                y0 = 1,
                id1 = 1,
                x1 = 0,
                y1 = 1,
            },
            {
                id0 = 100,
                x0 = 1,
                y0 = 2,
                id1 = 2,
                x1 = 0,
                y1 = 2,
            },
            {
                id0 = 100,
                x0 = 1,
                y0 = 3,
                id1 = 3,
                x1 = 0,
                y1 = 3,
            },
            {
                id0 = 100,
                x0 = 1,
                y0 = 4,
                id1 = 4,
                x1 = 0,
                y1 = 4,
            },
            {
                id0 = 100,
                x0 = 1,
                y0 = 5,
                id1 = 5,
                x1 = 0,
                y1 = 5,
            },
            {
                id0 = 100,
                x0 = 1,
                y0 = 6,
                id1 = 6,
                x1 = 0,
                y1 = 6,
            },
            {
                id0 = 100,
                x0 = 1,
                y0 = 6,
                id1 = 7,
                x1 = 1,
                y1 = 7,
            },
            {
                id0 = 100,
                x0 = 2,
                y0 = 6,
                id1 = 8,
                x1 = 2,
                y1 = 7,
            },
            {
                id0 = 9,
                x0 = 1,
                y0 = 0,
                id1 = 100,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 10,
                x0 = 2,
                y0 = 0,
                id1 = 100,
                x1 = 2,
                y1 = 1,
            },
            {
                id0 = 11,
                x0 = 3,
                y0 = 0,
                id1 = 100,
                x1 = 3,
                y1 = 1,
            },
            {
                id0 = 12,
                x0 = 4,
                y0 = 0,
                id1 = 100,
                x1 = 4,
                y1 = 1,
            },
            {
                id0 = 100,
                x0 = 3,
                y0 = 6,
                id1 = 13,
                x1 = 3,
                y1 = 7,
            },
            {
                id0 = 100,
                x0 = 4,
                y0 = 6,
                id1 = 14,
                x1 = 4,
                y1 = 7,
            },
            {
                id0 = 15,
                x0 = 6,
                y0 = 5,
                id1 = 100,
                x1 = 5,
                y1 = 5,
            },
            {
                id0 = 16,
                x0 = 6,
                y0 = 4,
                id1 = 100,
                x1 = 5,
                y1 = 4,
            },
            {
                id0 = 17,
                x0 = 6,
                y0 = 3,
                id1 = 100,
                x1 = 5,
                y1 = 3,
            },
            {
                id0 = 18,
                x0 = 6,
                y0 = 1,
                id1 = 100,
                x1 = 5,
                y1 = 1,
            },
            {
                id0 = 19,
                x0 = 6,
                y0 = 2,
                id1 = 100,
                x1 = 5,
                y1 = 2,
            },
            {
                id0 = 100,
                x0 = 5,
                y0 = 6,
                id1 = 20,
                x1 = 5,
                y1 = 7,
            },
            {
                id0 = 21,
                x0 = 5,
                y0 = 0,
                id1 = 100,
                x1 = 5,
                y1 = 1,
            },
            {
                id0 = 22,
                x0 = 6,
                y0 = 6,
                id1 = 100,
                x1 = 5,
                y1 = 6,
            },
            {
                id0 = 9,
                x0 = 1,
                y0 = 0,
                id1 = 100,
                x1 = 1,
                y1 = 1,
            },
            {
                id0 = 1,
                x0 = 0,
                y0 = 1,
                id1 = 100,
                x1 = 1,
                y1 = 1,
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
                id0 = 5,
                x0 = 0,
                y0 = 5,
                id1 = 100,
                x1 = 1,
                y1 = 5,
            },
            {
                id0 = 7,
                x0 = 1,
                y0 = 7,
                id1 = 100,
                x1 = 1,
                y1 = 6,
            },
            {
                id0 = 6,
                x0 = 0,
                y0 = 6,
                id1 = 100,
                x1 = 1,
                y1 = 6,
            },
            {
                id0 = 10,
                x0 = 2,
                y0 = 0,
                id1 = 100,
                x1 = 2,
                y1 = 1,
            },
            {
                id0 = 8,
                x0 = 2,
                y0 = 7,
                id1 = 100,
                x1 = 2,
                y1 = 6,
            },
        },
    },
    width = 5,
    height = 6,
    version = 1,
    tiles = tiles,
    walls = walls,
    units = units,
    decos = decos,
    lights = lights,
    sounds = sounds,
}
return export
