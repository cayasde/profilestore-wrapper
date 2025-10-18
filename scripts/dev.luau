local task = zune.task
local process = zune.process

task.spawn(function()
	process
		.create('rojo', { 'serve', 'test.project.json' }, { stdout = 'inherit' })
		:wait()
end)

task.spawn(function()
	process
		.create('rojo', {
			'sourcemap',
			'test.project.json',
			'--output',
			'sourcemap.json',
			'--watch',
		}, { stdout = 'inherit' })
		:wait()
end)
