module.exports =
	consumes: ['rest']
	provides: []
	setup: (options, imports, register)->
		rest = imports['rest'].app

		rest.user = name: 'user'

		register()