var argscheck = require('cordova/argscheck'),
	    channel = require('cordova/channel'),
	    utils = require('cordova/utils'),
	    exec = require('cordova/exec'),
	    cordova = require('cordova');
	
ExtractZipFilePlugin.prototype.unzipFile = function(successCallback, errorCallback) {
	exec(successCallback, errorCallback, "ExtractZipFilePlugin", "unzipFile", []);
};
	
module.exports = new ExtractZipFilePlugin();
