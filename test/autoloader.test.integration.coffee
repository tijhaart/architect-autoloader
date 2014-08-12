$path = require 'path'
$chai = require 'chai'

$autoloader = require '../'

expect = $chai.expect
fixturesPath = $path.join __dirname, '/fixtures'

describe "architect-autoloader (integration)", ->

	describe "register app events before app is ready/created by Architect", ->
		app = null

		before (done)->
			$autoloader("#{fixturesPath}/**/.plugin", fixturesPath, resolvedApp: false)
				.then (app)->
					app.on 'service', (name, service)->

						if name == 'pluginB'
							service.options.foo = 'foo'						

					app.$promise
				.then (_app)->
					app = _app
					done()
				.catch (err)->
					done(err)

		it 'should have changed a plugin setting', ->

			expect(app.services['pluginB'].options.foo).to.not.equal('bar') 
			expect(app.services['pluginB'].options.foo).to.equal('foo') 

			expect(app.services['pluginA2'].options.foo).to.equal('foo')
			expect(app.services['pluginA'].A2.options.foo).to.equal('foo')

