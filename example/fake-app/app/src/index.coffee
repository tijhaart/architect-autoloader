module.exports =
	consumes: ['hub'],
	provides: ['server.app'],
	setup: (options, imports, register)->
		hub = imports['hub']

		Server = -> return this
		Server:: =
			listen: (port, done)->
				this.port = port or 9000
				done()

		server = new Server()

		hub.on 'ready', ->
			server.listen 3000, onServerStarted = ()->
				console.log 'listening on port ' + server.port
				# example that user assigned to app and app assigned to server is ready in time
				console.log
					"server.app.user": server.app.user

		register null,
			"server.app": server