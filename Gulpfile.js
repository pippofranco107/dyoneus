const gulp = require('gulp');
const babel = require('gulp-babel');
const concat = require('gulp-concat');
const wrap = require('gulp-wrap');
const uglify = require('gulp-uglify');
const del = require('del');

gulp.task('default', ['server', 'static']);

gulp.task('server', function () {
  return gulp.src(['src/server.js']).pipe(gulp.dest('bin'));
});

gulp.task('static', ['lib', 'jsx'], function () {
  return gulp.src(['src/static/index.html']).pipe(gulp.dest('bin/static'));
});

gulp.task('lib', function () {
  return gulp.src(['src/static/lib/*']).pipe(gulp.dest('bin/static/lib'));
});

gulp.task('jsx', function () {
  return gulp.src([
      'src/static/jsx/Main.js',
  ])
      .pipe(babel({
        presets: ['react'],
      }))
      .pipe(concat('app.min.js'))
      .pipe(wrap(';(function(){<%= contents %>}());'))
      .pipe(uglify())
      .pipe(gulp.dest('bin/static'));
});

gulp.task('clean', function () {
  return del('bin');
});
