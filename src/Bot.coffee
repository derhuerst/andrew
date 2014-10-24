# dependencies
{EventEmitter}	= require 'events'
extend			= require 'extend'
logme			= require 'logme'
restify			= require 'restify'
bayes			= require 'bayes'
chalk			= require 'chalk'





class Bot extends EventEmitter



	version: null

	# the config hash
	config: null

	# a log object
	log: null

	# the HTTP server
	server: null

	# the input parser
	parser: null

	# a shared brain object
	brain: null

	# a hash of all plugins
	plugins: null



	constructor: (config) ->
		super()

		# package.json
		pkg = require '../package.json' or {}

		@version = pkg.version

		# config
		@config = extend true, {}, pkg.config, config

		# log
		@log = new logme.Logme
			theme: 'smile'

		# server
		@server = restify.createServer
			name: pkg.name
			version: pkg.version
		@server.get '/query/:query', @serverOnRequest

		# parser
		@parser = bayes()

		# brain
		@brain = {}

		# plugins
		plugins = @config.plugins or []
		@plugins = {}
		for plugin in plugins
			Plugin = require "../plugins/#{plugin}"
			@plugins[plugin] = new Plugin @parser, @brain
			@log.debug "plugin #{plugin} loaded"

		@server.listen @config.port or 8080, @serverOnListen


	serverOnRequest: (request, response, next) =>
		input = request.params.query
		success = (output = '') =>
			@log.info "#{chalk.gray '<'} #{output}"
			response.send
				status: 'ok'
				result: output
		failure = (error = {}) =>
			@log.error chalk.red error.message
			response.send extend error,
				status: 'error'
				result: error.message

		@log.info "#{chalk.gray '>'} #{input}"
		@query input, success, failure


	serverOnListen: () =>
		@log.info "listening at #{@server.url}"



	query: (input, success, failure) =>
		input = input or ''
		success = success or () ->
		failure = failure or () ->

		try
			@plugins[@parser.categorize input].query input, success, failure
		catch error
			failure error





module.exports = Bot