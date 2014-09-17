util = require("util")
path = require("path")
yeoman = require("yeoman-generator")
yosay = require("yosay")

RusicThemeGenerator = yeoman.generators.Base.extend(
  initializing: ->
    @pkg = require("../package.json")

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
        name: "coffeescript"
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
      {
        type: "input"
        name: "apikey"
        message: "What your API key?"
        default: "abc123"
      }
      {
        type: "input"
        name: "themeid"
        message: "What your Theme ID?"
        default: "1"
      }
    ]
    @prompt prompts, ((properties) ->
      @[property] = value for property, value of properties
      done()
    ).bind(this)

  writing:
    app: ->
      @scriptType = if @coffeescript then 'coffee' else 'js'
      @styleType = if @scss then 'scss' else 'css'

      # Create directories
      @dest.mkdir @scriptType
      @dest.mkdir "ideas"
      @dest.mkdir "layouts"

      # Copy directories
      @directory @styleType, @styleType
      @directory "ideas", "ideas"
      @directory "assets", "assets"

      # Templates
      @template "_package.json", "package.json", @
      @template "_bower.json", "bower.json", @
      @template "_attributes.yml", "attributes.yml", @
      @template "_gulpfile.coffee", "gulpfile.coffee", @
      @template "_rusic.yml", "rusic.yml", @
      @template "coffee/_index.coffee", "coffee/index.coffee", @

      @template "layouts/_subdomain.html.liquid", "layouts/subdomain.html.liquid", @

    projectfiles: ->
      @copy "bowerrc", ".bowerrc"
      @copy "_gulpfile.js", "gulpfile.js"
      @copy "gitignore", ".gitignore"

  end: ->
    @installDependencies();

    @log """

    Rusic
    =====

    Great your all set to start theming. Here's what you need to know -

    To compile your styles and scripts run -
    $ gulp

    To deploy to Rusic run -
    $ rusic deploy production

    """
)

module.exports = RusicThemeGenerator
