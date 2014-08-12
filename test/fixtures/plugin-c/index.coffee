module.exports =
	consumes: ['pluginD']
	provides: ['pluginC']
	setup: (options, imports, register)->
		C =
			__name: 'C'
			D: imports['pluginD']

		register null,
			pluginC: C