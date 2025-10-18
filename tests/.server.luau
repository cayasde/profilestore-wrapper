local Players = game:GetService('Players')
local ServerScriptService = game:GetService('ServerScriptService')
local create_profile = require(ServerScriptService.profile)

_G.__DEV__ = false

local template = { money = 0, rebirth = 0 }

local profile = create_profile()
	:set_template(template)
	:set_datastore_name('player-data')
	:use_mock(_G.__DEV__ or false)
	:initiate_default_lifecycle()

Players.PlayerAdded:Wait()
local player = Players:GetPlayers()[1]
local data = profile:get_data(player):expect()
print(data)
