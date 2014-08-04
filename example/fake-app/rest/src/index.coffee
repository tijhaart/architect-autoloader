module.exports =
	consumes: ['hub', 'server.app']
	provides: ['rest']
	setup: (options, imports, register)->
		hub 		= imports['hub']
		server 	= imports['server.app']

		App = ->
			return this

		app = new App()
		server.app = app

		hub.on 'ready', ->
			console.log
				rest: app
				server: server

		register null,
			rest:
				app: app