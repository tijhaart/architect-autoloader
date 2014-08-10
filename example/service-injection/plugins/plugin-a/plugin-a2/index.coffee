module.exports =
	consumes: ['pluginB']
	provides: ['pluginA2']
	packagePath: '/plugins/a2'
	setup: (options, imports, register)->
		A2 =
			__name: 'A2'

		register null,
			pluginA2: A2