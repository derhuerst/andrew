# dependencies
request			= require 'request'

Plugin			= require '../src/Plugin'





class JokePlugin extends Plugin



	constructor: (parser, brain) ->
		super parser, brain

		@parser.learn 'tell me a joke', 'joke'
		@parser.learn 'can you please tell me a joke?', 'joke'
		@parser.learn 'make me laugh', 'joke'



	query: (input, success, failure) ->
		request 'http://api.icndb.com/jokes/random', (error, response, body) ->
			if error
				failure new Error "coudn't connect to the jokes database"
			else
				try
					body = JSON.parse body
				catch
					console.log body
					failure new Error "syntax error in the jokes database response"
				success body.value.joke





module.exports = JokePlugin