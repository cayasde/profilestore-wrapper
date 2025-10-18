local process = zune.process

process.create('wally', { 'install' }, { stderr = 'inherit' }):wait()

process
	.create(
		'wally-package-types',
		{ '--sourcemap', 'sourcemap.json', 'Packages' },
		{ stderr = 'inherit' }
	)
	:wait()
