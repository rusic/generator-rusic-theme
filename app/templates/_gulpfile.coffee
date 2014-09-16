gulp = require("gulp")
gutil = require("gulp-util")
_ = require('lodash')
sass = require('gulp-ruby-sass')
coffee = require("gulp-coffee")
concat = require('gulp-concat')
livereload = require('gulp-livereload')
uglify = require('gulp-uglify')
gulpFilter = require('gulp-filter')

prefix = require('gulp-autoprefixer')


paths = {
  output: "assets"<% if (coffeescript) { %>
  coffee: "coffee/**/*.coffee"<% } %>
  js: "js/**/*.js"
  vendor: [
    "components/jquery-legacy/jquery.js"
  ]
  sass:
    "scss/style.scss"
}

gulp.task "scripts", ->
  combinedFiles = _.flatten([
    paths.vendor
    paths.js<% if (coffeescript) { %>
    paths.coffee<% } %>
  ])
  <% if (coffeescript) { %>
  coffeeFilter = gulpFilter("**/*.coffee")<% } %>

  gulp
    .src(combinedFiles)<% if (coffeescript) { %>
    .pipe(coffeeFilter)
    .pipe(coffee().on('error', gutil.log))
    .pipe(coffeeFilter.restore())<% } %>
    .pipe(concat("script.js"))
    .pipe(uglify())
    .pipe gulp.dest( paths.output )
    .pipe(livereload())

# gulp.task "sass", ->
#   gulp
#     .src(paths.sass)
#     .pipe(sass({
#       style: "compressed"
#     }))
#     .pipe gulp.dest(paths.output)

# gulp.task "watch", ->
#   gulp.watch ["scss/**/*.scss"], ["sass"]
#   gulp.watch ["coffee/**/*.coffee", "vendor/**/*.js"], ["scripts"]

gulp.task "default", ["scripts"]
