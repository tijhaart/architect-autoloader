autoloader = require '../../'

autoloader.findPlugins('../**/.module')

	# filter the plugins required for the test
	.then( (paths)->
		paths = paths.filter (path)->
			return path.indexOf('/fake-app/rest') > -1 or path.indexOf('/fake-app/security') > -1
		return paths
	)
	.then(autoloader.requirePlugins)

	# mock the server app
	.then( (plugins)->
		plugins.push
			packagePath: 'mocks/server.app'
			consumes: []
			provides: ['server.app']
			setup: (options, imports, register)->

				register null,
					'server.app': {} # mock
		return plugins
	)

	# create part of the app
	.then(autoloader.createApp '../fake-app')
	.then (app)->
		console.log '[test]'

		assert = require 'assert'

		server = app.services['server.app']
		rest = app.services['rest'].app

		assert.equal rest.accessToken.name, 'accessToken', 'should have assigned accessToken to rest app'
		assert.equal rest.acl.name, 'acl', 'should have assigned acl to rest app'

		assert.deepEqual server.rest, rest, 'should have assigned rest to server'



