
local entitiesPath 	= settings.paths.entities
local mapPath		= settings.paths.maps

--[[
                                                                          
88888888888                       88           88                         
88                         ,d     ""    ,d     ""                         
88                         88           88                                
88aaaaa      8b,dPPYba,  MM88MMM  88  MM88MMM  88   ,adPPYba,  ,adPPYba,  
88"""""      88P'   `"8a   88     88    88     88  a8P_____88  I8[    ""  
88           88       88   88     88    88     88  8PP"""""""   `"Y8ba,   
88           88       88   88,    88    88,    88  "8b,   ,aa  aa    ]8I  
88888888888  88       88   "Y888  88    "Y888  88   `"Ybbd8"'  `"YbbdP"'  
                                                                          
--]]

dofile(entitiesPath .."entity.lua")
dofile(entitiesPath .."debug_line.lua")
dofile(entitiesPath .."debug_point.lua")
dofile(entitiesPath .."player.lua")
dofile(entitiesPath .."platform.lua")

--[[
                                                                                                         
  ,ad8888ba,                                                        88                                   
 d8"'    `"8b                                                       88                ,d                 
d8'                                                                 88                88                 
88             ,adPPYYba,  88,dPYba,,adPYba,    ,adPPYba,   ,adPPYb,88  ,adPPYYba,  MM88MMM  ,adPPYYba,  
88      88888  ""     `Y8  88P'   "88"    "8a  a8P_____88  a8"    `Y88  ""     `Y8    88     ""     `Y8  
Y8,        88  ,adPPPPP88  88      88      88  8PP"""""""  8b       88  ,adPPPPP88    88     ,adPPPPP88  
 Y8a.    .a88  88,    ,88  88      88      88  "8b,   ,aa  "8a,   ,d88  88,    ,88    88,    88,    ,88  
  `"Y88888P"   `"8bbdP"Y8  88      88      88   `"Ybbd8"'   `"8bbdP"Y8  `"8bbdP"Y8    "Y888  `"8bbdP"Y8  
                                                                                                         
                                                                                                         
--]]

gamedata.load("circle", "shapes.dat")
gamedata.load("pentagon", "shapes.dat")
gamedata.load("hexagon", "shapes.dat")
gamedata.load("turret", "shapes.dat")
gamedata.load("bullet", "shapes.dat")

--[[
                                                       
88b           d88                                      
888b         d888                                      
88`8b       d8'88                                      
88 `8b     d8' 88  ,adPPYYba,  8b,dPPYba,   ,adPPYba,  
88  `8b   d8'  88  ""     `Y8  88P'    "8a  I8[    ""  
88   `8b d8'   88  ,adPPPPP88  88       d8   `"Y8ba,   
88    `888'    88  88,    ,88  88b,   ,a8"  aa    ]8I  
88     `8'     88  `"8bbdP"Y8  88`YbbdP"'   `"YbbdP"'  
                               88                      
                               88                      
--]]

dofile(mapPath .."map.lua")