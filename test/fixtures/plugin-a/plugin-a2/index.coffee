module.exports =
	consumes: ['pluginB']
	provides: ['pluginA2']
	packagePath: '/plugins/a2'
	setup: (options, imports, register)->
		pluginB = imports['pluginB']
		A2 =
			__name: 'A2'
			options:
				foo: pluginB.options.foo

		register null,
			pluginA2: A2