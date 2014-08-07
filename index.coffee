$architect 	= require 'architect'
$promise 		=	require 'bluebird'
$glob 			= require 'glob'
$path 			= require 'path'
$async 			= require 'async'

findPlugins = (glob)->
	new $promise (resolve, reject)->
		$glob glob, (err, plugins)->
			reject err if err

			reject new Error "No plugins found for pattern : '#{glob}'" if not plugins.length

			plugins = plugins.map (plugin)-> $path.resolve $path.dirname plugin
			resolve plugins

requirePlugins = (paths)->
	new $promise (resolve, reject)->

		reject new Error 'No plugins found' if not paths.length

		$async.map paths, (path, done)->
			# console.log $path.resolve path
			plugin = require resolvedPath = $path.resolve path
			plugin.packagePath = resolvedPath

			done null, plugin

		, (err, plugins)->
			reject err if err
			resolve plugins

createApp = (dirname)->
	(plugins)->
		new $promise (resolve, reject)->
			$architect.createApp ($architect.resolveConfig plugins, dirname), (err, app)->
				reject err if err
				resolve app

autoloader = (glob, dirname)->
	findPlugins(glob)
		.then(requirePlugins)
		.then(createApp dirname)
		.then (app)->
			console.info '[autoloader] architect app ready'
			return app
		.catch (err)->
			console.error '[autoloader] unable to create Architect app due to error(s)'
			throw err

autoloader.findPlugins = findPlugins
autoloader.requirePlugins = requirePlugins
autoloader.createApp = createApp

module.exports = autoloader
