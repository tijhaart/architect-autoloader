module.exports =
	consumes: []
	provides: ['pluginA1']
	setup: (options, imports, register)->
		A1 =
			__name: 'A1'

		register null,
			pluginA1: A1	