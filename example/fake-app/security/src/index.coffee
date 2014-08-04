module.exports =
	consumes: ['rest']
	provides: []
	setup: (options, imports, register)->
		rest = imports['rest'].app

		rest.acl = name: 'acl'
		rest.accessToken = name: 'accessToken'

		register()