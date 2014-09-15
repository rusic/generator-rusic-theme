"use strict"
util = require("util")
path = require("path")
yeoman = require("yeoman-generator")
yosay = require("yosay")

RusicThemeGenerator = yeoman.generators.Base.extend(
  initializing: ->
    @pkg = require("../package.json")
    @destinationRoot "./testing"

  prompting: ->
    done = @async()

    # Have Yeoman greet the user.
    @log yosay("Welcome to the Rusic Theme generator!")
    prompts = [
      {
        type: "confirm"
        name: "scss"
        message: "Would you like scss?"
        default: true
      }
      {
        type: "confirm"
        name: "coffee"
        message: "Would you like coffeescript?"
        default: true
      }
      {
        type: "input"
        name: "title"
        message: "What is the title of your theme?"
        default: "foo"
      }
      {
        type: "input"
        name: "description"
        message: "What is the description of your theme?"
        default: "bar"
      }
    ]
    @prompt prompts, ((properties) ->
      @[property] = value for property, value of properties
      done()
    ).bind(this)

  writing:
    app: ->
      @dest.mkdir "#{if @scss then 'scss' else 'css'}"

      @copy "_index.html", "index.html"

      @template "_package.json", "package.json", @
      @template "_bower.json", "bower.json", @

    projectfiles: ->
      # @src.copy "editorconfig", ".editorconfig"
      # @src.copy "jshintrc", ".jshintrc"

  end: ->
    @installDependencies();
)

module.exports = RusicThemeGenerator
