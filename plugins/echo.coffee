# dependencies
Plugin			= require '../src/Plugin'





class EchoPlugin extends Plugin



	constructor: (parser, brain) ->
		super parser, brain

		@parser.learn 'echo', 'echo'
		@parser.learn 'echo me', 'echo'
		@parser.learn 'this is an echo', 'echo'



	query: (input, success, failure) ->
		success input





module.exports = EchoPlugin