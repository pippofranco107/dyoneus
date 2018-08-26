const gulp = require('gulp');
const del = require('del');

gulp.task('default', function () {
  // TODO
});

gulp.task('clean', function () {
  return del('bin');
});
