module.exports =
	consumes: []
	provides: ['pluginB', 'pluginB.util']
	setup: (options, imports, register)->
		B =
			__name: 'B'

		register null,
			pluginB: B
			'pluginB.util': ->