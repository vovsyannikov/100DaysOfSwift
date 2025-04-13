//
//  Action.js
//  JavaScriptInjector
//
//  Created by Виталий Овсянников on 13.04.2025.
//

var Action = function() { }

Action.prototype = {
	run: function(parameters) {
		parameters.completionFunction({ "URL": document.URL, "title": document.title });
	},
	finalize: function(parameters) {
		var customJavaScript = parameters["customJavaScript"];
		eval(customJavaScript);
	}
};

var ExtensionPreprocessingJS = new Action
