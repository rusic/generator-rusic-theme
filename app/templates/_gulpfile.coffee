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
  coffee: "coffee/**/*.coffee"<% } %><% if (scss) { %>
  sass: "scss/style.scss"<% } %>
  js: "js/**/*.js"
  vendorJS: [
    "components/jquery-legacy/jquery.js"
    "components/bootstrap/dist/js/bootstrap.js"
  ]
  vendorCSS: [
    "components/bootstrap/dist/css/bootstrap.css"
  ]
}

gulp.task "scripts", ->
  combinedFiles = _.flatten([
    paths.vendorJS
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

gulp.task "styles", ->

  combinedFiles = _.flatten([
    paths.vendorCSS<% if (scss) { %>
    paths.sass<% } %>
  ])
  <% if (scss) { %>
  scssFilter = gulpFilter("**/*.scss")<% } %>

  gulp
    .src(combinedFiles)<% if (scss) { %>
    .pipe(scssFilter)
    .pipe(sass({
      style: "compressed"
    }))
    .pipe(scssFilter.restore())<% } %>
    .pipe(concat("style.css"))
    .pipe(prefix())
    .pipe gulp.dest( paths.output )
    .pipe(livereload())

gulp.task "watch", ->

  gulp.watch [
    paths.vendorJS
    paths.js<% if (coffeescript) { %>
    paths.coffee<% } %>
  ], ["scripts"]

  gulp.watch [
    paths.vendorCSS<% if (scss) { %>
    "**/*.scss"<% } %>
  ], ["styles"]

gulp.task "default", ["scripts", "styles", "watch"]
