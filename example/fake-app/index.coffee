autoloader 			= require '../../'
# search any folder that contains the .module file
# autoloader will require the index file in the same dir
# where the .module file is found
pluginGlobPttrn = './**/.module'

autoloader(pluginGlobPttrn, __dirname)
	.then (app)->
		console.log '[fake-app]', 'ready'
		console.log app: app