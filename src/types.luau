local profilestore = require(script.Parent.profilestore)
local promise = require(script.Parent.Parent.promise)

type Promise<T...> = promise.TypedPromise<T...>
export type Profile<Template> = profilestore.Profile<Template>

export type Interface<Template> = {
	_datastore_name: string,
	_store: profilestore.ProfileStore<Template>?,
	_template: Template?,
	_profiles: { [Player]: Profile<Template> },
	_mock_enabled: boolean,
	get_profile: (
		self: Interface<Template>,
		player: Player
	) -> Promise<Profile<Template>>,
	get_data: (self: Interface<Template>, player: Player) -> Promise<Template>,
	is_loaded: (self: Interface<Template>, player: Player) -> (),
	set_datastore_name: (
		self: Interface<Template>,
		name: string
	) -> Interface<Template>,
	set_template: (
		self: Interface<Template>,
		template: Template
	) -> Interface<Template>,
	initiate_default_lifecycle: (
		self: Interface<Template>
	) -> Interface<Template>,
	use_mock: (
		self: Interface<Template>,
		state: boolean
	) -> Interface<Template>,
}

return nil
