module.exports =
	consumes: ['pluginA1', 'pluginA2']
	provides: ['pluginA']
	setup: (options, imports, register)->
		A = 
			__name: 'A'
			A1: imports['pluginA1']
			A2: imports['pluginA2']

		register null,
			pluginA: A