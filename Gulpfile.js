const gulp = require('gulp');
const babel = require('gulp-babel');
const del = require('del');

gulp.task('default', ['server', 'static']);

gulp.task('server', function () {
  return gulp.src(['src/server.js']).pipe(gulp.dest('bin'));
});

gulp.task('static', ['index', 'lib', 'jsx']);

gulp.task('index', function () {
  return gulp.src(['src/static/index.html']).pipe(gulp.dest('bin/static'));
});

gulp.task('lib', function () {
  return gulp.src(['src/static/lib/*']).pipe(gulp.dest('bin/static/lib'));
});

gulp.task('jsx', function () {
  return gulp.src(['src/static/jsx/*.js'])
      .pipe(babel({
        presets: ['react'],
      }))
      .pipe(gulp.dest('bin/static/js'));
});

gulp.task('clean', function () {
  return del('bin');
});
