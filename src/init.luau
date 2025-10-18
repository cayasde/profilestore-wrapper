local initiate_default_lifecycle = require('@self/initiate_default_lifecycle')
local profilestore = require('@self/profilestore')
local promise = require(script.promise)
local types = require('@self/types')

type Profile<Template> = profilestore.Profile<Template>
type Interface<Template> = types.Interface<Template>

local initialized = false

local function use_mock<Template>(self: Interface<Template>, state: boolean)
	assert(self._store, 'Store not initialized.')
	if not state then return self end
	self._mock_enabled = true
	self._store = self._store.Mock :: any
	return self
end

local function set_datastore_name<Template>(self: Interface<Template>, name: string)
	assert(typeof(self._datastore_name) == 'nil', 'Datastore name already set.')
	assert(self._template, 'Template not set.')
	self._datastore_name = name
	self._store = profilestore.New(name, self._template :: any)
	return self
end

local function set_template<Template>(self: Interface<Template>, template: Template)
	assert(typeof(self._template) ~= 'table', 'Template already initialized.')
	self._template = template
	return self
end

local function is_loaded<Template>(self: Interface<Template>, player: Player)
	return if self._profiles[player] then true else false
end

local function get_profile<Template>(self: Interface<Template>, player: Player)
	return promise.new(function(resolve: (Profile<Template>) -> ())
		repeat
			task.wait()
		until self:is_loaded(player)
		resolve(self._profiles[player])
	end)
end

local function get_data<Template>(self: Interface<Template>, player: Player)
	return self:get_profile(player):andThen(function(profile)
		return profile.Data
	end)
end

return function<Template>(): Interface<Template>
	assert(not initialized, 'Already initialized.')
	initialized = true

	return {
		_profiles = {},
		_mock_enabled = false,
		_datastore_name = nil,
		_template = nil,
		_store = nil,
		get_profile = get_profile,
		get_data = get_data,
		is_loaded = is_loaded,
		set_datastore_name = set_datastore_name,
		set_template = set_template,
		initiate_default_lifecycle = initiate_default_lifecycle,
		use_mock = use_mock,
	} :: any
end
