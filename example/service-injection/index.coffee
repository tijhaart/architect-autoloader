autoloader = require '../../'

###*
 * Include a single service with it's dependencies
###
autoloader.findPlugins(__dirname + '/plugins/**/.plugin')
	.then(autoloader.requirePlugins)
	# include only the plugins that are required by pluginA and it's dependencies (consumes)
	# in this case pluginA1 and pluginA2 will be included but also pluginB because pluginA2 consumes pluginB
	.then(autoloader.filter('pluginA'))
	.then(autoloader.createApp __dirname)
	.then (app)->
		assert = require 'assert'

		assert.equal app.services['pluginC'], undefined
		assert.equal app.services['pluginD'], undefined

		assert.equal app.services['pluginA'].A1.__name, 'A1'
		assert.equal app.services['pluginA'].A2.__name, 'A2'

		assert.equal app.services['pluginA1'].__name, 'A1'
		assert.equal app.services['pluginA2'].__name, 'A2'

		assert.equal app.services['pluginB'].__name, 'B'

###*
 * Include multiple services with their dependencies
###
autoloader.findPlugins(__dirname + '/plugins/**/.plugin')
	.then(autoloader.requirePlugins)
	# include only the plugins that are required by pluginA and pluginD and their dependencies (consumes)
	# in this case pluginA1 and pluginA2 will be included but also pluginB because pluginA2 consumes pluginB
	.then(autoloader.filter(['pluginA', 'pluginD']))
	.then(autoloader.createApp __dirname)
	.then (app)->
		assert = require 'assert'

		assert.equal app.services['pluginC'], undefined
		assert.equal app.services['pluginD'].__name, 'D'

		assert.equal app.services['pluginA'].A1.__name, 'A1'
		assert.equal app.services['pluginA'].A2.__name, 'A2'

		assert.equal app.services['pluginA1'].__name, 'A1'
		assert.equal app.services['pluginA2'].__name, 'A2'

		assert.equal app.services['pluginB'].__name, 'B'