module.exports =
	consumes: []
	provides: ['pluginD']
	packagePath: '/plugins/d'
	setup: (options, imports, register)->
		D =
			__name: 'D'

		register null,
			pluginD: D