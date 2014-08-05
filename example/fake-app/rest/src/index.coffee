module.exports =
	consumes: ['hub', 'server.app']
	provides: ['rest']
	setup: (options, imports, register)->
		hub 		= imports['hub']
		server 	= imports['server.app']

		App = ->
			return this

		rest = new App()
		server.rest = rest

		hub.on 'ready', ->
			console.log
				rest: rest
				server: server

		register null,
			rest:
				app: rest