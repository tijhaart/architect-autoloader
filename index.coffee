$architect 	= require 'architect'
$promise 		=	require 'bluebird'
$glob 			= require 'glob'
$path 			= require 'path'
_ 					= require 'lodash'

###*
 * Find plugins based on a glob pattern e.g. "/plugins/**\/.plugin" (minus backslash)
 * 
 * @param  {String} glob Pattern
 * @return {Promise} A list of paths to found plugins
###
findPlugins = (glob)->
	new $promise (resolve, reject)->
		$glob glob, (err, plugins)->
			reject err if err
			reject new Error "No plugins found for pattern : '#{glob}'" if not plugins.length
			
			plugins = plugins.map (plugin)-> $path.resolve $path.dirname plugin
			resolve plugins

###*
 * Require plugins by the given paths. 
 * @param  {Array} paths 
 * @return {Promise}
###
requirePlugins = (paths)->
	new $promise (resolve, reject)->

		reject new Error 'No plugins found' if not paths.length

		$promise.map paths, (path)->
			plugin = require resolvedPath = $path.resolve path
			plugin.packagePath = resolvedPath
			return plugin

###*
 * Create an Architect app
 * 
 * @param  {String} dirname	- Root directory where local Architect plugins are placed
 * @param  {Boolean} options.resolvedApp - Returns app before ready and attaches the promise that resolves when the app is ready
 * @return {Function} 
###
createApp = (dirname, options={})->
	_.defaults options,
		resolvedApp: true

	###*
	 * Promise an Architect app based on architect resolved plugins
	 * @param  {Array} plugins A list of resolved Architect plugins (setup, provides, consumes)
	 * @return {Promise}
	###
	(plugins)->
		new $promise (resolve, reject)->
			if options.resolvedApp
				$architect.createApp ($architect.resolveConfig plugins, dirname), (err, app)->
					reject err if err
					resolve app
			else if not options.resolvedApp
				appCreated = $promise.pending()

				app = $architect.createApp ($architect.resolveConfig plugins, dirname), (err, app)->
					appCreated.reject app if err
					appCreated.resolve app

				app.$promise = appCreated.promise
				resolve app
			


# Return a filtered dependency list that contain the services,
# required by the provided services to function properly
# 
# @todo chain operations to return a filtered list of plugins
inject = (plugins, services)->

	getPluginIndex = (name)->
		_.findIndex plugins, (plugin)->
			plugin.provides.indexOf(name) > -1

	traverse = (consumes)->
		_plugins = []

		if consumes.length
			_plugins = _.reduce consumes, (_plugins, service)->
				index = getPluginIndex service
				_plugin = plugins[index]

				if _plugin
					_plugins = _plugins.concat traverse _plugin.consumes
					_plugins.push index

				return _plugins
			, []

		return _plugins

	# unique list of plugin indexes
	dependencies = []
	pluginList = []

	services = [services] if _.isString services

	pluginIndexes = _.reduce services, (pluginIndexes, serviceName)->
		pluginIndex = getPluginIndex serviceName
		plugin = plugins[pluginIndex]		
		dependencies.push pluginIndex

		if plugin.consumes.length
			pluginIndexes = traverse plugin.consumes

		return pluginIndexes
	, []

	pluginIndexes = _.uniq (dependencies.concat pluginIndexes).sort()

	# console.log pluginIndexes

	for pluginIndex in pluginIndexes 
		pluginList.push plugins[pluginIndex]

	return pluginList

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
autoloader.inject = inject

###*
 * Filter plugins before creating the app. 
 * Plugins require the resolved Architect plugin signature ({consumes:[], provides:[], setup: function})
 * 
 * @param  {String | Object | Object[]} services - Plugins that require the given services to function will be included
 * @return {Array} - A list of resolved Architect plugins
###
autoloader.filter = (services)->
	(plugins)-> autoloader.inject plugins, services

module.exports = autoloader
