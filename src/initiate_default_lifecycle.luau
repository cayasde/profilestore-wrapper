local Players = game:GetService('Players')

local types = require(script.Parent.types)
local initialized = false

type Interface<Template> = types.Interface<Template>

return function<Template>(self: Interface<Template>)
	assert(not initialized, 'Profile lifecyle already initialized.')

	local store = self._store
	local profiles = self._profiles

	local function player_added(player: Player)
		assert(store)

		local profile = store:StartSessionAsync(`Player_{player.UserId}`, {
			Cancel = function()
				return player.Parent ~= Players
			end,
		})

		if profile == nil then
			player:Kick(`Profile load fail - Please rejoin`)
			return
		end

		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile.OnSessionEnd:Connect(function()
			profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)

		if player.Parent ~= Players then
			player:Kick(`Profile load fail - Please rejoin`)
			return
		end

		profiles[player] = profile
	end

	for _, player in Players:GetPlayers() do
		player_added(player)
	end

	Players.PlayerAdded:Connect(player_added)
	Players.PlayerRemoving:Connect(function(player: Player)
		local profile = profiles[player]
		if profile ~= nil then profile:EndSession() end
	end)

	return self
end
