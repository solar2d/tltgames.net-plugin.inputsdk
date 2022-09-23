local Library = require "CoronaLibrary"

-- Create library
local lib = Library:new{ name='plugin.inputsdk', publisherId='tltgames.net' }

local warningMessage = "WARNING: plugin not supported on current platform"

lib.initialize = function() print(warningMessage) end;

lib.isSupported = function() return false end;

lib.setUpMouseSettings = function() print(warningMessage) end;

lib.getKeyEvents = function() print(warningMessage) end;

lib.getMouseActions = function() print(warningMessage) end;

lib.addMapping = function() print(warningMessage) end;

lib.addMappingGroup = function() print(warningMessage) end;

lib.deleteMapping = function() print(warningMessage) end;

lib.deleteMappingGroup = function() print(warningMessage) end;

lib.hasMapping = function() print(warningMessage) end;

lib.hasMappingGroup = function() print(warningMessage) end;

lib.bindMappings = function() print(warningMessage) end;

lib.unbindMappings = function() print(warningMessage) end;


return lib
