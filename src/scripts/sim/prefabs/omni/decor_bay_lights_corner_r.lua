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
}
local units =
{
}
local decos =
{
    {
        x = 2,
        y = 1,
        kanim = [[decor_sk_bay_walllights1]],
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
        },
    },
    width = 3,
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
