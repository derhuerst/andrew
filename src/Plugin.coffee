class Plugin



	# a reference to the bot's parser
	parser: null

	# a reference to the bot's brain
	brain: null



	constructor: (parser, brain) ->
		@parser = parser
		@brain = brain





module.exports = Plugin