/******/ (function(modules) { // webpackBootstrap
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotDownloadUpdateChunk(chunkId) {
/******/ 		var chunk = require("./" + "" + chunkId + "." + hotCurrentHash + ".hot-update.js");
/******/ 		hotAddUpdateChunk(chunk.id, chunk.modules);
/******/ 	}
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotDownloadManifest() {
/******/ 		try {
/******/ 			var update = require("./" + "" + hotCurrentHash + ".hot-update.json");
/******/ 		} catch (e) {
/******/ 			return Promise.resolve();
/******/ 		}
/******/ 		return Promise.resolve(update);
/******/ 	}
/******/
/******/ 	//eslint-disable-next-line no-unused-vars
/******/ 	function hotDisposeChunk(chunkId) {
/******/ 		delete installedChunks[chunkId];
/******/ 	}
/******/
/******/ 	var hotApplyOnUpdate = true;
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	var hotCurrentHash = "76a5fd8510937c817b72";
/******/ 	var hotRequestTimeout = 10000;
/******/ 	var hotCurrentModuleData = {};
/******/ 	var hotCurrentChildModule;
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	var hotCurrentParents = [];
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	var hotCurrentParentsTemp = [];
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotCreateRequire(moduleId) {
/******/ 		var me = installedModules[moduleId];
/******/ 		if (!me) return __webpack_require__;
/******/ 		var fn = function(request) {
/******/ 			if (me.hot.active) {
/******/ 				if (installedModules[request]) {
/******/ 					if (installedModules[request].parents.indexOf(moduleId) === -1) {
/******/ 						installedModules[request].parents.push(moduleId);
/******/ 					}
/******/ 				} else {
/******/ 					hotCurrentParents = [moduleId];
/******/ 					hotCurrentChildModule = request;
/******/ 				}
/******/ 				if (me.children.indexOf(request) === -1) {
/******/ 					me.children.push(request);
/******/ 				}
/******/ 			} else {
/******/ 				console.warn(
/******/ 					"[HMR] unexpected require(" +
/******/ 						request +
/******/ 						") from disposed module " +
/******/ 						moduleId
/******/ 				);
/******/ 				hotCurrentParents = [];
/******/ 			}
/******/ 			return __webpack_require__(request);
/******/ 		};
/******/ 		var ObjectFactory = function ObjectFactory(name) {
/******/ 			return {
/******/ 				configurable: true,
/******/ 				enumerable: true,
/******/ 				get: function() {
/******/ 					return __webpack_require__[name];
/******/ 				},
/******/ 				set: function(value) {
/******/ 					__webpack_require__[name] = value;
/******/ 				}
/******/ 			};
/******/ 		};
/******/ 		for (var name in __webpack_require__) {
/******/ 			if (
/******/ 				Object.prototype.hasOwnProperty.call(__webpack_require__, name) &&
/******/ 				name !== "e" &&
/******/ 				name !== "t"
/******/ 			) {
/******/ 				Object.defineProperty(fn, name, ObjectFactory(name));
/******/ 			}
/******/ 		}
/******/ 		fn.e = function(chunkId) {
/******/ 			if (hotStatus === "ready") hotSetStatus("prepare");
/******/ 			hotChunksLoading++;
/******/ 			return __webpack_require__.e(chunkId).then(finishChunkLoading, function(err) {
/******/ 				finishChunkLoading();
/******/ 				throw err;
/******/ 			});
/******/
/******/ 			function finishChunkLoading() {
/******/ 				hotChunksLoading--;
/******/ 				if (hotStatus === "prepare") {
/******/ 					if (!hotWaitingFilesMap[chunkId]) {
/******/ 						hotEnsureUpdateChunk(chunkId);
/******/ 					}
/******/ 					if (hotChunksLoading === 0 && hotWaitingFiles === 0) {
/******/ 						hotUpdateDownloaded();
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 		fn.t = function(value, mode) {
/******/ 			if (mode & 1) value = fn(value);
/******/ 			return __webpack_require__.t(value, mode & ~1);
/******/ 		};
/******/ 		return fn;
/******/ 	}
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotCreateModule(moduleId) {
/******/ 		var hot = {
/******/ 			// private stuff
/******/ 			_acceptedDependencies: {},
/******/ 			_declinedDependencies: {},
/******/ 			_selfAccepted: false,
/******/ 			_selfDeclined: false,
/******/ 			_disposeHandlers: [],
/******/ 			_main: hotCurrentChildModule !== moduleId,
/******/
/******/ 			// Module API
/******/ 			active: true,
/******/ 			accept: function(dep, callback) {
/******/ 				if (dep === undefined) hot._selfAccepted = true;
/******/ 				else if (typeof dep === "function") hot._selfAccepted = dep;
/******/ 				else if (typeof dep === "object")
/******/ 					for (var i = 0; i < dep.length; i++)
/******/ 						hot._acceptedDependencies[dep[i]] = callback || function() {};
/******/ 				else hot._acceptedDependencies[dep] = callback || function() {};
/******/ 			},
/******/ 			decline: function(dep) {
/******/ 				if (dep === undefined) hot._selfDeclined = true;
/******/ 				else if (typeof dep === "object")
/******/ 					for (var i = 0; i < dep.length; i++)
/******/ 						hot._declinedDependencies[dep[i]] = true;
/******/ 				else hot._declinedDependencies[dep] = true;
/******/ 			},
/******/ 			dispose: function(callback) {
/******/ 				hot._disposeHandlers.push(callback);
/******/ 			},
/******/ 			addDisposeHandler: function(callback) {
/******/ 				hot._disposeHandlers.push(callback);
/******/ 			},
/******/ 			removeDisposeHandler: function(callback) {
/******/ 				var idx = hot._disposeHandlers.indexOf(callback);
/******/ 				if (idx >= 0) hot._disposeHandlers.splice(idx, 1);
/******/ 			},
/******/
/******/ 			// Management API
/******/ 			check: hotCheck,
/******/ 			apply: hotApply,
/******/ 			status: function(l) {
/******/ 				if (!l) return hotStatus;
/******/ 				hotStatusHandlers.push(l);
/******/ 			},
/******/ 			addStatusHandler: function(l) {
/******/ 				hotStatusHandlers.push(l);
/******/ 			},
/******/ 			removeStatusHandler: function(l) {
/******/ 				var idx = hotStatusHandlers.indexOf(l);
/******/ 				if (idx >= 0) hotStatusHandlers.splice(idx, 1);
/******/ 			},
/******/
/******/ 			//inherit from previous dispose call
/******/ 			data: hotCurrentModuleData[moduleId]
/******/ 		};
/******/ 		hotCurrentChildModule = undefined;
/******/ 		return hot;
/******/ 	}
/******/
/******/ 	var hotStatusHandlers = [];
/******/ 	var hotStatus = "idle";
/******/
/******/ 	function hotSetStatus(newStatus) {
/******/ 		hotStatus = newStatus;
/******/ 		for (var i = 0; i < hotStatusHandlers.length; i++)
/******/ 			hotStatusHandlers[i].call(null, newStatus);
/******/ 	}
/******/
/******/ 	// while downloading
/******/ 	var hotWaitingFiles = 0;
/******/ 	var hotChunksLoading = 0;
/******/ 	var hotWaitingFilesMap = {};
/******/ 	var hotRequestedFilesMap = {};
/******/ 	var hotAvailableFilesMap = {};
/******/ 	var hotDeferred;
/******/
/******/ 	// The update info
/******/ 	var hotUpdate, hotUpdateNewHash;
/******/
/******/ 	function toModuleId(id) {
/******/ 		var isNumber = +id + "" === id;
/******/ 		return isNumber ? +id : id;
/******/ 	}
/******/
/******/ 	function hotCheck(apply) {
/******/ 		if (hotStatus !== "idle") {
/******/ 			throw new Error("check() is only allowed in idle status");
/******/ 		}
/******/ 		hotApplyOnUpdate = apply;
/******/ 		hotSetStatus("check");
/******/ 		return hotDownloadManifest(hotRequestTimeout).then(function(update) {
/******/ 			if (!update) {
/******/ 				hotSetStatus("idle");
/******/ 				return null;
/******/ 			}
/******/ 			hotRequestedFilesMap = {};
/******/ 			hotWaitingFilesMap = {};
/******/ 			hotAvailableFilesMap = update.c;
/******/ 			hotUpdateNewHash = update.h;
/******/
/******/ 			hotSetStatus("prepare");
/******/ 			var promise = new Promise(function(resolve, reject) {
/******/ 				hotDeferred = {
/******/ 					resolve: resolve,
/******/ 					reject: reject
/******/ 				};
/******/ 			});
/******/ 			hotUpdate = {};
/******/ 			var chunkId = "example";
/******/ 			// eslint-disable-next-line no-lone-blocks
/******/ 			{
/******/ 				hotEnsureUpdateChunk(chunkId);
/******/ 			}
/******/ 			if (
/******/ 				hotStatus === "prepare" &&
/******/ 				hotChunksLoading === 0 &&
/******/ 				hotWaitingFiles === 0
/******/ 			) {
/******/ 				hotUpdateDownloaded();
/******/ 			}
/******/ 			return promise;
/******/ 		});
/******/ 	}
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotAddUpdateChunk(chunkId, moreModules) {
/******/ 		if (!hotAvailableFilesMap[chunkId] || !hotRequestedFilesMap[chunkId])
/******/ 			return;
/******/ 		hotRequestedFilesMap[chunkId] = false;
/******/ 		for (var moduleId in moreModules) {
/******/ 			if (Object.prototype.hasOwnProperty.call(moreModules, moduleId)) {
/******/ 				hotUpdate[moduleId] = moreModules[moduleId];
/******/ 			}
/******/ 		}
/******/ 		if (--hotWaitingFiles === 0 && hotChunksLoading === 0) {
/******/ 			hotUpdateDownloaded();
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotEnsureUpdateChunk(chunkId) {
/******/ 		if (!hotAvailableFilesMap[chunkId]) {
/******/ 			hotWaitingFilesMap[chunkId] = true;
/******/ 		} else {
/******/ 			hotRequestedFilesMap[chunkId] = true;
/******/ 			hotWaitingFiles++;
/******/ 			hotDownloadUpdateChunk(chunkId);
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotUpdateDownloaded() {
/******/ 		hotSetStatus("ready");
/******/ 		var deferred = hotDeferred;
/******/ 		hotDeferred = null;
/******/ 		if (!deferred) return;
/******/ 		if (hotApplyOnUpdate) {
/******/ 			// Wrap deferred object in Promise to mark it as a well-handled Promise to
/******/ 			// avoid triggering uncaught exception warning in Chrome.
/******/ 			// See https://bugs.chromium.org/p/chromium/issues/detail?id=465666
/******/ 			Promise.resolve()
/******/ 				.then(function() {
/******/ 					return hotApply(hotApplyOnUpdate);
/******/ 				})
/******/ 				.then(
/******/ 					function(result) {
/******/ 						deferred.resolve(result);
/******/ 					},
/******/ 					function(err) {
/******/ 						deferred.reject(err);
/******/ 					}
/******/ 				);
/******/ 		} else {
/******/ 			var outdatedModules = [];
/******/ 			for (var id in hotUpdate) {
/******/ 				if (Object.prototype.hasOwnProperty.call(hotUpdate, id)) {
/******/ 					outdatedModules.push(toModuleId(id));
/******/ 				}
/******/ 			}
/******/ 			deferred.resolve(outdatedModules);
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotApply(options) {
/******/ 		if (hotStatus !== "ready")
/******/ 			throw new Error("apply() is only allowed in ready status");
/******/ 		options = options || {};
/******/
/******/ 		var cb;
/******/ 		var i;
/******/ 		var j;
/******/ 		var module;
/******/ 		var moduleId;
/******/
/******/ 		function getAffectedStuff(updateModuleId) {
/******/ 			var outdatedModules = [updateModuleId];
/******/ 			var outdatedDependencies = {};
/******/
/******/ 			var queue = outdatedModules.map(function(id) {
/******/ 				return {
/******/ 					chain: [id],
/******/ 					id: id
/******/ 				};
/******/ 			});
/******/ 			while (queue.length > 0) {
/******/ 				var queueItem = queue.pop();
/******/ 				var moduleId = queueItem.id;
/******/ 				var chain = queueItem.chain;
/******/ 				module = installedModules[moduleId];
/******/ 				if (!module || module.hot._selfAccepted) continue;
/******/ 				if (module.hot._selfDeclined) {
/******/ 					return {
/******/ 						type: "self-declined",
/******/ 						chain: chain,
/******/ 						moduleId: moduleId
/******/ 					};
/******/ 				}
/******/ 				if (module.hot._main) {
/******/ 					return {
/******/ 						type: "unaccepted",
/******/ 						chain: chain,
/******/ 						moduleId: moduleId
/******/ 					};
/******/ 				}
/******/ 				for (var i = 0; i < module.parents.length; i++) {
/******/ 					var parentId = module.parents[i];
/******/ 					var parent = installedModules[parentId];
/******/ 					if (!parent) continue;
/******/ 					if (parent.hot._declinedDependencies[moduleId]) {
/******/ 						return {
/******/ 							type: "declined",
/******/ 							chain: chain.concat([parentId]),
/******/ 							moduleId: moduleId,
/******/ 							parentId: parentId
/******/ 						};
/******/ 					}
/******/ 					if (outdatedModules.indexOf(parentId) !== -1) continue;
/******/ 					if (parent.hot._acceptedDependencies[moduleId]) {
/******/ 						if (!outdatedDependencies[parentId])
/******/ 							outdatedDependencies[parentId] = [];
/******/ 						addAllToSet(outdatedDependencies[parentId], [moduleId]);
/******/ 						continue;
/******/ 					}
/******/ 					delete outdatedDependencies[parentId];
/******/ 					outdatedModules.push(parentId);
/******/ 					queue.push({
/******/ 						chain: chain.concat([parentId]),
/******/ 						id: parentId
/******/ 					});
/******/ 				}
/******/ 			}
/******/
/******/ 			return {
/******/ 				type: "accepted",
/******/ 				moduleId: updateModuleId,
/******/ 				outdatedModules: outdatedModules,
/******/ 				outdatedDependencies: outdatedDependencies
/******/ 			};
/******/ 		}
/******/
/******/ 		function addAllToSet(a, b) {
/******/ 			for (var i = 0; i < b.length; i++) {
/******/ 				var item = b[i];
/******/ 				if (a.indexOf(item) === -1) a.push(item);
/******/ 			}
/******/ 		}
/******/
/******/ 		// at begin all updates modules are outdated
/******/ 		// the "outdated" status can propagate to parents if they don't accept the children
/******/ 		var outdatedDependencies = {};
/******/ 		var outdatedModules = [];
/******/ 		var appliedUpdate = {};
/******/
/******/ 		var warnUnexpectedRequire = function warnUnexpectedRequire() {
/******/ 			console.warn(
/******/ 				"[HMR] unexpected require(" + result.moduleId + ") to disposed module"
/******/ 			);
/******/ 		};
/******/
/******/ 		for (var id in hotUpdate) {
/******/ 			if (Object.prototype.hasOwnProperty.call(hotUpdate, id)) {
/******/ 				moduleId = toModuleId(id);
/******/ 				/** @type {TODO} */
/******/ 				var result;
/******/ 				if (hotUpdate[id]) {
/******/ 					result = getAffectedStuff(moduleId);
/******/ 				} else {
/******/ 					result = {
/******/ 						type: "disposed",
/******/ 						moduleId: id
/******/ 					};
/******/ 				}
/******/ 				/** @type {Error|false} */
/******/ 				var abortError = false;
/******/ 				var doApply = false;
/******/ 				var doDispose = false;
/******/ 				var chainInfo = "";
/******/ 				if (result.chain) {
/******/ 					chainInfo = "\nUpdate propagation: " + result.chain.join(" -> ");
/******/ 				}
/******/ 				switch (result.type) {
/******/ 					case "self-declined":
/******/ 						if (options.onDeclined) options.onDeclined(result);
/******/ 						if (!options.ignoreDeclined)
/******/ 							abortError = new Error(
/******/ 								"Aborted because of self decline: " +
/******/ 									result.moduleId +
/******/ 									chainInfo
/******/ 							);
/******/ 						break;
/******/ 					case "declined":
/******/ 						if (options.onDeclined) options.onDeclined(result);
/******/ 						if (!options.ignoreDeclined)
/******/ 							abortError = new Error(
/******/ 								"Aborted because of declined dependency: " +
/******/ 									result.moduleId +
/******/ 									" in " +
/******/ 									result.parentId +
/******/ 									chainInfo
/******/ 							);
/******/ 						break;
/******/ 					case "unaccepted":
/******/ 						if (options.onUnaccepted) options.onUnaccepted(result);
/******/ 						if (!options.ignoreUnaccepted)
/******/ 							abortError = new Error(
/******/ 								"Aborted because " + moduleId + " is not accepted" + chainInfo
/******/ 							);
/******/ 						break;
/******/ 					case "accepted":
/******/ 						if (options.onAccepted) options.onAccepted(result);
/******/ 						doApply = true;
/******/ 						break;
/******/ 					case "disposed":
/******/ 						if (options.onDisposed) options.onDisposed(result);
/******/ 						doDispose = true;
/******/ 						break;
/******/ 					default:
/******/ 						throw new Error("Unexception type " + result.type);
/******/ 				}
/******/ 				if (abortError) {
/******/ 					hotSetStatus("abort");
/******/ 					return Promise.reject(abortError);
/******/ 				}
/******/ 				if (doApply) {
/******/ 					appliedUpdate[moduleId] = hotUpdate[moduleId];
/******/ 					addAllToSet(outdatedModules, result.outdatedModules);
/******/ 					for (moduleId in result.outdatedDependencies) {
/******/ 						if (
/******/ 							Object.prototype.hasOwnProperty.call(
/******/ 								result.outdatedDependencies,
/******/ 								moduleId
/******/ 							)
/******/ 						) {
/******/ 							if (!outdatedDependencies[moduleId])
/******/ 								outdatedDependencies[moduleId] = [];
/******/ 							addAllToSet(
/******/ 								outdatedDependencies[moduleId],
/******/ 								result.outdatedDependencies[moduleId]
/******/ 							);
/******/ 						}
/******/ 					}
/******/ 				}
/******/ 				if (doDispose) {
/******/ 					addAllToSet(outdatedModules, [result.moduleId]);
/******/ 					appliedUpdate[moduleId] = warnUnexpectedRequire;
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// Store self accepted outdated modules to require them later by the module system
/******/ 		var outdatedSelfAcceptedModules = [];
/******/ 		for (i = 0; i < outdatedModules.length; i++) {
/******/ 			moduleId = outdatedModules[i];
/******/ 			if (
/******/ 				installedModules[moduleId] &&
/******/ 				installedModules[moduleId].hot._selfAccepted &&
/******/ 				// removed self-accepted modules should not be required
/******/ 				appliedUpdate[moduleId] !== warnUnexpectedRequire
/******/ 			) {
/******/ 				outdatedSelfAcceptedModules.push({
/******/ 					module: moduleId,
/******/ 					errorHandler: installedModules[moduleId].hot._selfAccepted
/******/ 				});
/******/ 			}
/******/ 		}
/******/
/******/ 		// Now in "dispose" phase
/******/ 		hotSetStatus("dispose");
/******/ 		Object.keys(hotAvailableFilesMap).forEach(function(chunkId) {
/******/ 			if (hotAvailableFilesMap[chunkId] === false) {
/******/ 				hotDisposeChunk(chunkId);
/******/ 			}
/******/ 		});
/******/
/******/ 		var idx;
/******/ 		var queue = outdatedModules.slice();
/******/ 		while (queue.length > 0) {
/******/ 			moduleId = queue.pop();
/******/ 			module = installedModules[moduleId];
/******/ 			if (!module) continue;
/******/
/******/ 			var data = {};
/******/
/******/ 			// Call dispose handlers
/******/ 			var disposeHandlers = module.hot._disposeHandlers;
/******/ 			for (j = 0; j < disposeHandlers.length; j++) {
/******/ 				cb = disposeHandlers[j];
/******/ 				cb(data);
/******/ 			}
/******/ 			hotCurrentModuleData[moduleId] = data;
/******/
/******/ 			// disable module (this disables requires from this module)
/******/ 			module.hot.active = false;
/******/
/******/ 			// remove module from cache
/******/ 			delete installedModules[moduleId];
/******/
/******/ 			// when disposing there is no need to call dispose handler
/******/ 			delete outdatedDependencies[moduleId];
/******/
/******/ 			// remove "parents" references from all children
/******/ 			for (j = 0; j < module.children.length; j++) {
/******/ 				var child = installedModules[module.children[j]];
/******/ 				if (!child) continue;
/******/ 				idx = child.parents.indexOf(moduleId);
/******/ 				if (idx >= 0) {
/******/ 					child.parents.splice(idx, 1);
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// remove outdated dependency from module children
/******/ 		var dependency;
/******/ 		var moduleOutdatedDependencies;
/******/ 		for (moduleId in outdatedDependencies) {
/******/ 			if (
/******/ 				Object.prototype.hasOwnProperty.call(outdatedDependencies, moduleId)
/******/ 			) {
/******/ 				module = installedModules[moduleId];
/******/ 				if (module) {
/******/ 					moduleOutdatedDependencies = outdatedDependencies[moduleId];
/******/ 					for (j = 0; j < moduleOutdatedDependencies.length; j++) {
/******/ 						dependency = moduleOutdatedDependencies[j];
/******/ 						idx = module.children.indexOf(dependency);
/******/ 						if (idx >= 0) module.children.splice(idx, 1);
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// Now in "apply" phase
/******/ 		hotSetStatus("apply");
/******/
/******/ 		hotCurrentHash = hotUpdateNewHash;
/******/
/******/ 		// insert new code
/******/ 		for (moduleId in appliedUpdate) {
/******/ 			if (Object.prototype.hasOwnProperty.call(appliedUpdate, moduleId)) {
/******/ 				modules[moduleId] = appliedUpdate[moduleId];
/******/ 			}
/******/ 		}
/******/
/******/ 		// call accept handlers
/******/ 		var error = null;
/******/ 		for (moduleId in outdatedDependencies) {
/******/ 			if (
/******/ 				Object.prototype.hasOwnProperty.call(outdatedDependencies, moduleId)
/******/ 			) {
/******/ 				module = installedModules[moduleId];
/******/ 				if (module) {
/******/ 					moduleOutdatedDependencies = outdatedDependencies[moduleId];
/******/ 					var callbacks = [];
/******/ 					for (i = 0; i < moduleOutdatedDependencies.length; i++) {
/******/ 						dependency = moduleOutdatedDependencies[i];
/******/ 						cb = module.hot._acceptedDependencies[dependency];
/******/ 						if (cb) {
/******/ 							if (callbacks.indexOf(cb) !== -1) continue;
/******/ 							callbacks.push(cb);
/******/ 						}
/******/ 					}
/******/ 					for (i = 0; i < callbacks.length; i++) {
/******/ 						cb = callbacks[i];
/******/ 						try {
/******/ 							cb(moduleOutdatedDependencies);
/******/ 						} catch (err) {
/******/ 							if (options.onErrored) {
/******/ 								options.onErrored({
/******/ 									type: "accept-errored",
/******/ 									moduleId: moduleId,
/******/ 									dependencyId: moduleOutdatedDependencies[i],
/******/ 									error: err
/******/ 								});
/******/ 							}
/******/ 							if (!options.ignoreErrored) {
/******/ 								if (!error) error = err;
/******/ 							}
/******/ 						}
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// Load self accepted modules
/******/ 		for (i = 0; i < outdatedSelfAcceptedModules.length; i++) {
/******/ 			var item = outdatedSelfAcceptedModules[i];
/******/ 			moduleId = item.module;
/******/ 			hotCurrentParents = [moduleId];
/******/ 			try {
/******/ 				__webpack_require__(moduleId);
/******/ 			} catch (err) {
/******/ 				if (typeof item.errorHandler === "function") {
/******/ 					try {
/******/ 						item.errorHandler(err);
/******/ 					} catch (err2) {
/******/ 						if (options.onErrored) {
/******/ 							options.onErrored({
/******/ 								type: "self-accept-error-handler-errored",
/******/ 								moduleId: moduleId,
/******/ 								error: err2,
/******/ 								originalError: err
/******/ 							});
/******/ 						}
/******/ 						if (!options.ignoreErrored) {
/******/ 							if (!error) error = err2;
/******/ 						}
/******/ 						if (!error) error = err;
/******/ 					}
/******/ 				} else {
/******/ 					if (options.onErrored) {
/******/ 						options.onErrored({
/******/ 							type: "self-accept-errored",
/******/ 							moduleId: moduleId,
/******/ 							error: err
/******/ 						});
/******/ 					}
/******/ 					if (!options.ignoreErrored) {
/******/ 						if (!error) error = err;
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// handle errors in accept handlers and self accepted module load
/******/ 		if (error) {
/******/ 			hotSetStatus("fail");
/******/ 			return Promise.reject(error);
/******/ 		}
/******/
/******/ 		hotSetStatus("idle");
/******/ 		return new Promise(function(resolve) {
/******/ 			resolve(outdatedModules);
/******/ 		});
/******/ 	}
/******/
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {},
/******/ 			hot: hotCreateModule(moduleId),
/******/ 			parents: (hotCurrentParentsTemp = hotCurrentParents, hotCurrentParents = [], hotCurrentParentsTemp),
/******/ 			children: []
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, hotCreateRequire(moduleId));
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// __webpack_hash__
/******/ 	__webpack_require__.h = function() { return hotCurrentHash; };
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return hotCreateRequire("./src/example/example.ts")(__webpack_require__.s = "./src/example/example.ts");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./src/base.ts":
/*!*********************!*\
  !*** ./src/base.ts ***!
  \*********************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
class OutField {
    constructor(key, outKey, convert) {
        this.key = key;
        this.outKey = outKey;
        this.convert = convert;
        if (outKey == null)
            this.outKey = key;
    }
}
exports.OutField = OutField;
class Buildable {
    build() { }
}
exports.Buildable = Buildable;
class Widget extends Buildable {
    constructor(widgetName, outFields = []) {
        super();
        this._outFields = [];
        this._widget = widgetName;
        this.addFields(outFields);
    }
    addFields(fields) {
        this._outFields.push(...fields.map(v => {
            if (typeof v == "string")
                return new OutField(v);
            return v;
        }));
    }
    build() {
        const map = {};
        if (this._widget != null) {
            map['type'] = this._widget;
        }
        this._outFields.forEach(field => {
            let val = this[field.key];
            if (typeof val === 'undefined' || val === null)
                return;
            while (true) {
                if (val instanceof Buildable) {
                    val = val.build();
                }
                else {
                    break;
                }
            }
            if (typeof val === "object" && Array.isArray(val)) {
                val = val.map((v) => {
                    while (true) {
                        if (v instanceof Buildable) {
                            v = v.build();
                        }
                        else {
                            break;
                        }
                    }
                    return v;
                });
            }
            if (field.convert) {
                val = field.convert(val);
            }
            map[field.outKey] = val;
        });
        return map;
    }
}
exports.Widget = Widget;


/***/ }),

/***/ "./src/example/example.ts":
/*!********************************!*\
  !*** ./src/example/example.ts ***!
  \********************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const __1 = __webpack_require__(/*! .. */ "./src/index.ts");
const aspect_ratio_1 = __webpack_require__(/*! ../widget/basic/aspect_ratio */ "./src/widget/basic/aspect_ratio.ts");
class MiniChip extends __1.Widget {
    constructor(label, color = __1.Color.fromARGB(10, 40, 40, 40), radius = 4, padding = __1.EdgeInsets.all(4)) {
        super();
        this.label = label;
        this.color = color;
        this.radius = radius;
        this.padding = padding;
    }
    build() {
        return __1.Container({
            color: this.color,
            // decoration 暂时不支持
            padding: this.padding,
            child: this.label,
        });
    }
}
const pageW = __1.Column({
    children: [
        __1.Padding({
            padding: __1.EdgeInsets.symmetric({
                vertical: 8.0,
                horizontal: 16.0,
            }),
            child: __1.Text("标题"),
        }),
        __1.Padding({
            padding: __1.EdgeInsets.symmetric({
                vertical: 8.0,
                horizontal: 16.0,
            }),
            child: __1.Row({
                crossAxisAlignment: __1.CrossAxisAlignment.start,
                children: [
                    __1.Container({
                        height: 180.0,
                        child: aspect_ratio_1.AspectRatio({
                            aspectRatio: 128 / 182,
                            child: __1.Image.asset('assets/images/test5.png', {
                                boxFit: __1.BoxFit.cover,
                            }),
                        })
                    }),
                    __1.SizedBox({
                        width: 16.0,
                    }),
                    __1.Expanded({
                        child: __1.Container({
                            child: __1.Column({
                                crossAxisAlignment: __1.CrossAxisAlignment.stretch,
                                children: [
                                    __1.Row({
                                        children: [
                                            __1.Container({
                                                child: __1.Text("发布于"),
                                                width: 50.0,
                                                alignment: __1.Alignment.centerRight,
                                            }),
                                            __1.SizedBox({ width: 4.0 }),
                                            __1.Text("2020-02-02 20:02"),
                                        ]
                                    }),
                                    __1.Row({
                                        children: [
                                            __1.Container({
                                                child: __1.Text("属性2"),
                                                width: 50.0,
                                                alignment: __1.Alignment.centerRight,
                                            }),
                                            __1.SizedBox({ width: 4.0 }),
                                            __1.Text("值2"),
                                        ]
                                    }),
                                    __1.Row({
                                        children: [
                                            __1.Container({
                                                child: __1.Text("属性2"),
                                                width: 50.0,
                                                alignment: __1.Alignment.centerRight,
                                            }),
                                            __1.SizedBox({ width: 4.0 }),
                                            __1.Text("值2"),
                                        ]
                                    }),
                                    __1.Row({
                                        children: [
                                            __1.Container({
                                                child: __1.Text("属性2"),
                                                width: 50.0,
                                                alignment: __1.Alignment.centerRight,
                                            }),
                                            __1.SizedBox({ width: 4.0 }),
                                            __1.Text("值2"),
                                        ]
                                    }),
                                    __1.Row({
                                        children: [
                                            __1.Container({
                                                child: __1.Text("属性2"),
                                                width: 50.0,
                                                alignment: __1.Alignment.centerRight,
                                            }),
                                            __1.SizedBox({ width: 4.0 }),
                                            __1.Text("值2"),
                                        ]
                                    }),
                                    __1.RaisedButton({
                                        child: __1.Text("查看"),
                                    }),
                                ]
                            })
                        }),
                    })
                ]
            }),
        }),
        __1.Padding({
            padding: __1.EdgeInsets.symmetric({
                vertical: 8,
                horizontal: 16,
            }),
            child: __1.Wrap({
                spacing: 4,
                runSpacing: 4,
                children: [
                    new MiniChip(__1.Text("标签1")),
                    new MiniChip(__1.Text("标签2")),
                    new MiniChip(__1.Text("标签3")),
                    new MiniChip(__1.Text("标签4")),
                    new MiniChip(__1.Text("标签5")),
                    new MiniChip(__1.Text("标签6")),
                    new MiniChip(__1.Text("标签7")),
                ],
            }),
        }),
    ],
});
flutter.print('test1');
flutter.showPage(JSON.stringify(pageW.build()));
flutter.print('test2');


/***/ }),

/***/ "./src/index.ts":
/*!**********************!*\
  !*** ./src/index.ts ***!
  \**********************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

function __export(m) {
    for (var p in m) if (!exports.hasOwnProperty(p)) exports[p] = m[p];
}
Object.defineProperty(exports, "__esModule", { value: true });
__export(__webpack_require__(/*! ./base */ "./src/base.ts"));
__export(__webpack_require__(/*! ./types */ "./src/types.ts"));
var align_1 = __webpack_require__(/*! ./widget/basic/align */ "./src/widget/basic/align.ts");
exports.Align = align_1.Align;
var column_1 = __webpack_require__(/*! ./widget/basic/column */ "./src/widget/basic/column.ts");
exports.Column = column_1.Column;
var container_1 = __webpack_require__(/*! ./widget/basic/container */ "./src/widget/basic/container.ts");
exports.Container = container_1.Container;
var raised_button_1 = __webpack_require__(/*! ./widget/basic/raised_button */ "./src/widget/basic/raised_button.ts");
exports.RaisedButton = raised_button_1.RaisedButton;
var row_1 = __webpack_require__(/*! ./widget/basic/row */ "./src/widget/basic/row.ts");
exports.Row = row_1.Row;
var stack_1 = __webpack_require__(/*! ./widget/basic/stack */ "./src/widget/basic/stack.ts");
exports.Stack = stack_1.Stack;
var text_1 = __webpack_require__(/*! ./widget/basic/text */ "./src/widget/basic/text.ts");
exports.Text = text_1.Text;
var padding_1 = __webpack_require__(/*! ./widget/basic/padding */ "./src/widget/basic/padding.ts");
exports.Padding = padding_1.Padding;
var expanded_1 = __webpack_require__(/*! ./widget/basic/expanded */ "./src/widget/basic/expanded.ts");
exports.Expanded = expanded_1.Expanded;
var expanded_sized_box_1 = __webpack_require__(/*! ./widget/basic/expanded_sized_box */ "./src/widget/basic/expanded_sized_box.ts");
exports.ExpandedSizedBox = expanded_sized_box_1.ExpandedSizedBox;
var sized_box_1 = __webpack_require__(/*! ./widget/basic/sized_box */ "./src/widget/basic/sized_box.ts");
exports.SizedBox = sized_box_1.SizedBox;
var opacity_1 = __webpack_require__(/*! ./widget/basic/opacity */ "./src/widget/basic/opacity.ts");
exports.Opacity = opacity_1.Opacity;
var wrap_1 = __webpack_require__(/*! ./widget/basic/wrap */ "./src/widget/basic/wrap.ts");
exports.Wrap = wrap_1.Wrap;
var image_1 = __webpack_require__(/*! ./widget/basic/image */ "./src/widget/basic/image.ts");
exports.Image = image_1.Image;
var box_constraints_1 = __webpack_require__(/*! ./property/box_constraints */ "./src/property/box_constraints.ts");
exports.BoxConstraints = box_constraints_1.BoxConstraints;
var color_1 = __webpack_require__(/*! ./property/color */ "./src/property/color.ts");
exports.Color = color_1.Color;
var edgeInsets_param_1 = __webpack_require__(/*! ./property/edgeInsets_param */ "./src/property/edgeInsets_param.ts");
exports.EdgeInsets = edgeInsets_param_1.EdgeInsets;
var text_style_1 = __webpack_require__(/*! ./property/text_style */ "./src/property/text_style.ts");
exports.TextStyle = text_style_1.TextStyle;


/***/ }),

/***/ "./src/property/box_constraints.ts":
/*!*****************************************!*\
  !*** ./src/property/box_constraints.ts ***!
  \*****************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../base */ "./src/base.ts");
class BoxConstraintsProperty extends base_1.Widget {
    constructor(param) {
        super(null, ['minWidth', 'maxWidth', 'minHeight', 'maxHeight']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.BoxConstraintsProperty = BoxConstraintsProperty;
function BoxConstraints(param) {
    return new BoxConstraintsProperty(param);
}
exports.BoxConstraints = BoxConstraints;


/***/ }),

/***/ "./src/property/color.ts":
/*!*******************************!*\
  !*** ./src/property/color.ts ***!
  \*******************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../base */ "./src/base.ts");
class ColorProperty extends base_1.Buildable {
    constructor(value) {
        super();
        this.value = value;
    }
    get alpha() {
        return (0xff000000 & this.value) >> 24;
    }
    get opacity() {
        return this.alpha / 0xFF;
    }
    get red() {
        return (0x00ff0000 & this.value) >> 16;
    }
    get green() {
        return (0x0000ff00 & this.value) >> 8;
    }
    get blue() {
        return (0x000000ff & this.value) >> 0;
    }
    withAlpha(a) {
        return Color.fromARGB(a, this.red, this.green, this.blue);
    }
    withOpacity(o) {
        return Color.fromRGBO(this.red, this.green, this.blue, o);
    }
    withRed(r) {
        return Color.fromARGB(this.alpha, r, this.green, this.blue);
    }
    withGreen(g) {
        return Color.fromARGB(this.alpha, this.red, g, this.blue);
    }
    withBlue(b) {
        return Color.fromARGB(this.alpha, this.red, this.green, b);
    }
    build() {
        return this.value;
    }
}
exports.ColorProperty = ColorProperty;
function Color(color) {
    return new ColorProperty(color);
}
exports.Color = Color;
Color.fromARGB = (a, r, g, b) => {
    const value = (((a & 0xff) << 24) |
        ((r & 0xff) << 16) |
        ((g & 0xff) << 8) |
        ((b & 0xff) << 0)) & 0xFFFFFFFF;
    return new ColorProperty(value);
};
Color.fromRGBO = (r, g, b, opacity) => {
    const value = (((Math.floor(opacity * 0xff / 1) & 0xff) << 24) |
        ((r & 0xff) << 16) |
        ((g & 0xff) << 8) |
        ((b & 0xff) << 0)) & 0xFFFFFFFF;
    return new ColorProperty(value);
};


/***/ }),

/***/ "./src/property/edgeInsets_param.ts":
/*!******************************************!*\
  !*** ./src/property/edgeInsets_param.ts ***!
  \******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../base */ "./src/base.ts");
class EdgeInsetsProperty extends base_1.Buildable {
    constructor(left, top, right, bottom) {
        super();
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
    }
    build() {
        return [this.left, this.top, this.right, this.bottom].toString();
    }
}
exports.EdgeInsetsProperty = EdgeInsetsProperty;
/// css style
function EdgeInsets(top, right, bottom, left) {
    if (typeof top === "number" && typeof right === "number" && typeof bottom === "number" && typeof left === "number") {
        return new EdgeInsetsProperty(left, top, right, bottom);
    }
    else if (typeof top === "number" && typeof right === "number" && typeof bottom === "number") {
        return new EdgeInsetsProperty(right, top, right, bottom);
    }
    else if (typeof top === "number" && typeof right === "number") {
        return new EdgeInsetsProperty(right, top, right, top);
    }
    else if (typeof top === "number") {
        return new EdgeInsetsProperty(top, top, top, top);
    }
    else {
        return new EdgeInsetsProperty(0, 0, 0, 0);
    }
}
exports.EdgeInsets = EdgeInsets;
EdgeInsets.all = (v) => {
    return new EdgeInsetsProperty(v, v, v, v);
};
EdgeInsets.fromLTRB = (left, top, right, bottom) => {
    return new EdgeInsetsProperty(left, top, right, bottom);
};
EdgeInsets.fromLTRB = (left, top, right, bottom) => {
    return new EdgeInsetsProperty(left, top, right, bottom);
};
EdgeInsets.only = (param) => {
    return new EdgeInsetsProperty(param.left, param.top, param.right, param.bottom);
};
EdgeInsets.symmetric = (param) => {
    return new EdgeInsetsProperty(param.horizontal, param.vertical, param.horizontal, param.vertical);
};


/***/ }),

/***/ "./src/property/text_style.ts":
/*!************************************!*\
  !*** ./src/property/text_style.ts ***!
  \************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../base */ "./src/base.ts");
class TextStyleProperty extends base_1.Widget {
    constructor(param) {
        super(null, ['color', 'debugLabel', 'decoration', 'fontFamily', 'fontSize', 'fontStyle', 'fontWeight']);
        this.color = param.color;
        this.debugLabel = param.debugLabel;
        this.decoration = param.decoration;
        this.fontFamily = param.fontFamily;
        this.fontSize = param.fontSize;
        this.fontStyle = param.fontStyle;
        this.fontWeight = param.fontWeight;
    }
}
exports.TextStyleProperty = TextStyleProperty;
function TextStyle(param) {
    return new TextStyleProperty(param);
}
exports.TextStyle = TextStyle;


/***/ }),

/***/ "./src/types.ts":
/*!**********************!*\
  !*** ./src/types.ts ***!
  \**********************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var Alignment;
(function (Alignment) {
    Alignment["topLeft"] = "topLeft";
    Alignment["topCenter"] = "topCenter";
    Alignment["topRight"] = "topRight";
    Alignment["centerLeft"] = "centerLeft";
    Alignment["center"] = "center";
    Alignment["centerRight"] = "centerRight";
    Alignment["bottomLeft"] = "bottomLeft";
    Alignment["bottomCenter"] = "bottomCenter";
    Alignment["bottomRight"] = "bottomRight";
})(Alignment = exports.Alignment || (exports.Alignment = {}));
var TextAlign;
(function (TextAlign) {
    TextAlign["left"] = "left";
    TextAlign["right"] = "right";
    TextAlign["center"] = "center";
    TextAlign["justify"] = "justify";
    TextAlign["start"] = "start";
    TextAlign["end"] = "end";
})(TextAlign = exports.TextAlign || (exports.TextAlign = {}));
var TextOverflow;
(function (TextOverflow) {
    TextOverflow["ellipsis"] = "ellipsis";
    TextOverflow["clip"] = "clip";
    TextOverflow["fade"] = "fade";
})(TextOverflow = exports.TextOverflow || (exports.TextOverflow = {}));
var TextDecoration;
(function (TextDecoration) {
    TextDecoration["lineThrough"] = "lineThrough";
    TextDecoration["overline"] = "overline";
    TextDecoration["underline"] = "underline";
})(TextDecoration = exports.TextDecoration || (exports.TextDecoration = {}));
var TextDirection;
(function (TextDirection) {
    TextDirection["ltr"] = "ltr";
    TextDirection["rtl"] = "rtl";
})(TextDirection = exports.TextDirection || (exports.TextDirection = {}));
var FontWeight;
(function (FontWeight) {
    FontWeight["w100"] = "w100";
    FontWeight["w200"] = "w200";
    FontWeight["w300"] = "w300";
    FontWeight["normal"] = "normal";
    FontWeight["w400"] = "w400";
    FontWeight["w500"] = "w500";
    FontWeight["w600"] = "w600";
    FontWeight["w700"] = "w700";
    FontWeight["w800"] = "w800";
    FontWeight["w900"] = "w900";
    FontWeight["bold"] = "bold";
})(FontWeight = exports.FontWeight || (exports.FontWeight = {}));
var FontStyle;
(function (FontStyle) {
    FontStyle["italic"] = "italic";
    FontStyle["normal"] = "normal";
})(FontStyle = exports.FontStyle || (exports.FontStyle = {}));
var CrossAxisAlignment;
(function (CrossAxisAlignment) {
    CrossAxisAlignment["start"] = "start";
    CrossAxisAlignment["end"] = "end";
    CrossAxisAlignment["center"] = "center";
    CrossAxisAlignment["stretch"] = "stretch";
    CrossAxisAlignment["baseline"] = "baseline";
})(CrossAxisAlignment = exports.CrossAxisAlignment || (exports.CrossAxisAlignment = {}));
var MainAxisSize;
(function (MainAxisSize) {
    MainAxisSize["min"] = "min";
    MainAxisSize["max"] = "max";
})(MainAxisSize = exports.MainAxisSize || (exports.MainAxisSize = {}));
var MainAxisAlignment;
(function (MainAxisAlignment) {
    MainAxisAlignment["start"] = "start";
    MainAxisAlignment["end"] = "end";
    MainAxisAlignment["center"] = "center";
    MainAxisAlignment["spaceBetween"] = "spaceBetween";
    MainAxisAlignment["spaceAround"] = "spaceAround";
    MainAxisAlignment["spaceEvenly"] = "spaceEvenly";
})(MainAxisAlignment = exports.MainAxisAlignment || (exports.MainAxisAlignment = {}));
var TextBaseline;
(function (TextBaseline) {
    TextBaseline["alphabetic"] = "alphabetic";
    TextBaseline["ideographic"] = "ideographic";
})(TextBaseline = exports.TextBaseline || (exports.TextBaseline = {}));
var VerticalDirection;
(function (VerticalDirection) {
    VerticalDirection["up"] = "up";
    VerticalDirection["down"] = "down";
})(VerticalDirection = exports.VerticalDirection || (exports.VerticalDirection = {}));
var StackFit;
(function (StackFit) {
    StackFit["loose"] = "loose";
    StackFit["expand"] = "expand";
    StackFit["passthrough"] = "passthrough";
})(StackFit = exports.StackFit || (exports.StackFit = {}));
var Overflow;
(function (Overflow) {
    Overflow["visible"] = "visible";
    Overflow["clip"] = "clip";
})(Overflow = exports.Overflow || (exports.Overflow = {}));
var Axis;
(function (Axis) {
    Axis["horizontal"] = "horizontal";
    Axis["vertical"] = "vertical";
})(Axis = exports.Axis || (exports.Axis = {}));
var WrapAlignment;
(function (WrapAlignment) {
    WrapAlignment["start"] = "start";
    WrapAlignment["end"] = "end";
    WrapAlignment["center"] = "center";
    WrapAlignment["spaceBetween"] = "spaceBetween";
    WrapAlignment["spaceAround"] = "spaceAround";
    WrapAlignment["spaceEvenly"] = "spaceEvenly";
})(WrapAlignment = exports.WrapAlignment || (exports.WrapAlignment = {}));
var BlendMode;
(function (BlendMode) {
    BlendMode["clear"] = "clear";
    BlendMode["src"] = "src";
    BlendMode["dst"] = "dst";
    BlendMode["srcOver"] = "srcOver";
    BlendMode["dstOver"] = "dstOver";
    BlendMode["srcIn"] = "srcIn";
    BlendMode["dstIn"] = "dstIn";
    BlendMode["srcOut"] = "srcOut";
    BlendMode["dstOut"] = "dstOut";
    BlendMode["srcATop"] = "srcATop";
    BlendMode["dstATop"] = "dstATop";
    BlendMode["xor"] = "xor";
    BlendMode["plus"] = "plus";
    BlendMode["modulate"] = "modulate";
    BlendMode["screen"] = "screen";
    BlendMode["overlay"] = "overlay";
    BlendMode["darken"] = "darken";
    BlendMode["lighten"] = "lighten";
    BlendMode["colorDodge"] = "colorDodge";
    BlendMode["colorBurn"] = "colorBurn";
    BlendMode["hardLight"] = "hardLight";
    BlendMode["softLight"] = "softLight";
    BlendMode["difference"] = "difference";
    BlendMode["exclusion"] = "exclusion";
    BlendMode["multiply"] = "multiply";
    BlendMode["hue"] = "hue";
    BlendMode["saturation"] = "saturation";
    BlendMode["color"] = "color";
    BlendMode["luminosity"] = "luminosity";
})(BlendMode = exports.BlendMode || (exports.BlendMode = {}));
var BoxFit;
(function (BoxFit) {
    BoxFit["fill"] = "fill";
    BoxFit["contain"] = "contain";
    BoxFit["cover"] = "cover";
    BoxFit["fitWidth"] = "fitWidth";
    BoxFit["fitHeight"] = "fitHeight";
    BoxFit["none"] = "none";
    BoxFit["scaleDown"] = "scaleDown";
})(BoxFit = exports.BoxFit || (exports.BoxFit = {}));
var ImageRepeat;
(function (ImageRepeat) {
    ImageRepeat["repeat"] = "repeat";
    ImageRepeat["repeatX"] = "repeatX";
    ImageRepeat["repeatY"] = "repeatY";
    ImageRepeat["noRepeat"] = "noRepeat";
})(ImageRepeat = exports.ImageRepeat || (exports.ImageRepeat = {}));
var FilterQuality;
(function (FilterQuality) {
    FilterQuality["none"] = "none";
    FilterQuality["low"] = "low";
    FilterQuality["medium"] = "medium";
    FilterQuality["high"] = "high";
})(FilterQuality = exports.FilterQuality || (exports.FilterQuality = {}));


/***/ }),

/***/ "./src/widget/basic/align.ts":
/*!***********************************!*\
  !*** ./src/widget/basic/align.ts ***!
  \***********************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class AlignWidget extends base_1.Widget {
    constructor(param) {
        super('Align', ['child', 'alignment', 'widthFactor', 'heightFactor']);
        this.child = param.child;
        this.alignment = param.alignment;
        this.widthFactor = param.widthFactor;
        this.heightFactor = param.heightFactor;
    }
}
exports.AlignWidget = AlignWidget;
function Align(param) {
    return new AlignWidget(param);
}
exports.Align = Align;


/***/ }),

/***/ "./src/widget/basic/aspect_ratio.ts":
/*!******************************************!*\
  !*** ./src/widget/basic/aspect_ratio.ts ***!
  \******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class AspectRatioWidget extends base_1.Widget {
    constructor(param) {
        super('AspectRatio', ['child', 'aspectRatio']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.AspectRatioWidget = AspectRatioWidget;
function AspectRatio(param) { return new AspectRatioWidget(param); }
exports.AspectRatio = AspectRatio;
;


/***/ }),

/***/ "./src/widget/basic/column.ts":
/*!************************************!*\
  !*** ./src/widget/basic/column.ts ***!
  \************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class ColumnWidget extends base_1.Widget {
    constructor(param) {
        super('Column', ['children', 'crossAxisAlignment', 'mainAxisAlignment', 'mainAxisSize', 'textBaseline', 'textDirection', 'verticalDirection']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.ColumnWidget = ColumnWidget;
function Column(param) {
    return new ColumnWidget(param);
}
exports.Column = Column;


/***/ }),

/***/ "./src/widget/basic/container.ts":
/*!***************************************!*\
  !*** ./src/widget/basic/container.ts ***!
  \***************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class ContainerWidget extends base_1.Widget {
    constructor(param) {
        super('Container', ['child', 'alignment', 'width', 'height', 'margin', 'padding', 'color', 'constraints']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.ContainerWidget = ContainerWidget;
function Container(param) { return new ContainerWidget(param); }
exports.Container = Container;
;


/***/ }),

/***/ "./src/widget/basic/expanded.ts":
/*!**************************************!*\
  !*** ./src/widget/basic/expanded.ts ***!
  \**************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class ExpandedWidget extends base_1.Widget {
    constructor(param) {
        super('Expanded', ['child', 'flex']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.ExpandedWidget = ExpandedWidget;
function Expanded(param) { return new ExpandedWidget(param); }
exports.Expanded = Expanded;
;


/***/ }),

/***/ "./src/widget/basic/expanded_sized_box.ts":
/*!************************************************!*\
  !*** ./src/widget/basic/expanded_sized_box.ts ***!
  \************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class ExpandedSizedBoxWidget extends base_1.Widget {
    constructor(param) {
        super('ExpandedSizedBox', ['child']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.ExpandedSizedBoxWidget = ExpandedSizedBoxWidget;
function ExpandedSizedBox(param) { return new ExpandedSizedBoxWidget(param); }
exports.ExpandedSizedBox = ExpandedSizedBox;
;


/***/ }),

/***/ "./src/widget/basic/image.ts":
/*!***********************************!*\
  !*** ./src/widget/basic/image.ts ***!
  \***********************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class ImageBaseWidget extends base_1.Widget {
    // todo: click_event;
    constructor(widgetName, outFields = []) {
        super(widgetName, [
            'semanticLabel', 'excludeFromSemantics', 'scale',
            'width', 'height', 'color', 'blendMode', 'boxFit', 'alignment',
            'repeat', 'matchTextDirection', 'gaplessPlayback', 'filterQuality',
            ...outFields
        ]);
    }
}
exports.ImageBaseWidget = ImageBaseWidget;
class NetworkImageWidget extends ImageBaseWidget {
    constructor(src, param) {
        super('NetworkImage', ['src']);
        this.src = src;
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.NetworkImageWidget = NetworkImageWidget;
class AssetImageWidget extends ImageBaseWidget {
    constructor(name, param) {
        super('AssetImage', ['name']);
        this.name = name;
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.AssetImageWidget = AssetImageWidget;
class FileImageWidget extends ImageBaseWidget {
    constructor(filePath, param) {
        super('AssetImage', ['name']);
        this.filePath = filePath;
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.FileImageWidget = FileImageWidget;
function Image() { }
exports.Image = Image;
Image.network = (src, param) => {
    return new NetworkImageWidget(src, param);
};
Image.asset = (name, param) => {
    return new AssetImageWidget(name, param);
};
Image.file = (filePath, param) => {
    return new FileImageWidget(filePath, param);
};


/***/ }),

/***/ "./src/widget/basic/opacity.ts":
/*!*************************************!*\
  !*** ./src/widget/basic/opacity.ts ***!
  \*************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class OpacityWidget extends base_1.Widget {
    constructor(param) {
        super('Opacity', ['child', 'opacity', 'alwaysIncludeSemantics']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.OpacityWidget = OpacityWidget;
function Opacity(param) { return new OpacityWidget(param); }
exports.Opacity = Opacity;
;


/***/ }),

/***/ "./src/widget/basic/padding.ts":
/*!*************************************!*\
  !*** ./src/widget/basic/padding.ts ***!
  \*************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class PaddingWidget extends base_1.Widget {
    constructor(param) {
        super('Padding', ['child', 'padding']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.PaddingWidget = PaddingWidget;
function Padding(param) { return new PaddingWidget(param); }
exports.Padding = Padding;
;


/***/ }),

/***/ "./src/widget/basic/raised_button.ts":
/*!*******************************************!*\
  !*** ./src/widget/basic/raised_button.ts ***!
  \*******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class RaisedButtonWidget extends base_1.Widget {
    constructor(param) {
        super('RaisedButton', [
            'child', 'color', 'disabledColor', 'disabledElevation',
            'disabledTextColor', 'padding', 'elevation',
            'splashColor', 'textColor'
        ]);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.RaisedButtonWidget = RaisedButtonWidget;
function RaisedButton(param) {
    return new RaisedButtonWidget(param);
}
exports.RaisedButton = RaisedButton;


/***/ }),

/***/ "./src/widget/basic/row.ts":
/*!*********************************!*\
  !*** ./src/widget/basic/row.ts ***!
  \*********************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class RowWidget extends base_1.Widget {
    constructor(param) {
        super('Row', ['children', 'crossAxisAlignment', 'mainAxisAlignment', 'mainAxisSize', 'textBaseline', 'textDirection', 'verticalDirection']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.RowWidget = RowWidget;
function Row(param) {
    return new RowWidget(param);
}
exports.Row = Row;


/***/ }),

/***/ "./src/widget/basic/sized_box.ts":
/*!***************************************!*\
  !*** ./src/widget/basic/sized_box.ts ***!
  \***************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class SizedBoxWidget extends base_1.Widget {
    constructor(param) {
        super('SizedBox', ['child', 'width', 'height']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.SizedBoxWidget = SizedBoxWidget;
function SizedBox(param) { return new SizedBoxWidget(param); }
exports.SizedBox = SizedBox;
;


/***/ }),

/***/ "./src/widget/basic/stack.ts":
/*!***********************************!*\
  !*** ./src/widget/basic/stack.ts ***!
  \***********************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class StackWidget extends base_1.Widget {
    constructor(param) {
        super('Stack', ['children', 'alignment', 'fit', 'overflow', 'textDirection']);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.StackWidget = StackWidget;
function Stack(param) {
    return new StackWidget(param);
}
exports.Stack = Stack;


/***/ }),

/***/ "./src/widget/basic/text.ts":
/*!**********************************!*\
  !*** ./src/widget/basic/text.ts ***!
  \**********************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class TextWidget extends base_1.Widget {
    constructor(data, param) {
        super('Text', ['data', 'textAlign', 'overflow', 'maxLines', 'semanticsLabel', 'softWrap', 'textDirection', 'textScaleFactor', 'style']);
        this.data = data;
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.TextWidget = TextWidget;
function Text(data, param) {
    return new TextWidget(data, param);
}
exports.Text = Text;


/***/ }),

/***/ "./src/widget/basic/wrap.ts":
/*!**********************************!*\
  !*** ./src/widget/basic/wrap.ts ***!
  \**********************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
const base_1 = __webpack_require__(/*! ../../base */ "./src/base.ts");
class WrapWidget extends base_1.Widget {
    constructor(param) {
        super('Wrap', [
            'children', 'alignment', 'crossAxisAlignment', 'direction', 'runAlignment',
            'runSpacing', 'spacing', 'textDirection', 'verticalDirection'
        ]);
        if (param)
            for (let key in param)
                this[key] = param[key];
    }
}
exports.WrapWidget = WrapWidget;
function Wrap(param) { return new WrapWidget(param); }
exports.Wrap = Wrap;
;


/***/ })

/******/ });
//# sourceMappingURL=example.js.map