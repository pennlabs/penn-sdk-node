var should = require('should')
var registrar = require('./index')

var ID = 'UPENN_OD_emjR_1000041'
var PW = 'atvganiimuifudf1r9b6htpibg'

function logRes(err, data) {
  console.log('\n\n--------------------------')
  console.log('Error', err)
  console.log('Data', data)
}

function succ(cb) {
  return function (err, data) {
    console.log('Testing for success')
    should.not.exist(err)
    cb(data)
  }
}

function err() {
  return function (err, data) {
    console.log('Testing for failure')
    should.exist(err)
  }
}
// describe('Registrar', function () {
  var reg = new registrar.Registrar(ID, PW)

  // describe('#courseInfo()', function () {

    // it('should return a single course correctly', function (done) {
      reg.courseInfo('cis', '120', succ(function (data) {
        data.should.have.property('department', 'CIS')
        data.should.have.property('course_number', '120')
        // done()
      }))

      reg.courseInfo('engl', '40', succ(function (data) {
        data.should.have.property('department', 'ENGL')
        data.should.have.property('course_number', '040')
        // done()
      }))
    // })

    // it('should error on nonexistant courses', function (done) {
      reg.courseInfo('abc', '120', err())
      reg.courseInfo('cis', '087', err())
      reg.courseInfo('cis', '87', err())      
    // })
  // })

  // describe('#departmentCourses()', function () {

    // it('should return a department of courses correctly', function (done) {
      reg.departmentCourses('cis', succ(function (data) {
        data.meta.should.have.property('current_page_number', 1)
        data.meta.should.have.property('number_of_pages', 7)
        data.should.have.lengthOf(20)
      }))      
    // })

    // it('should handle paging params correctly', function (done) {
      reg.departmentCourses('cis', {page_number: 2}, succ(function (data) {
        data.meta.should.have.property('current_page_number', 2)
        // done()
      }))

      reg.departmentCourses('cis', {results_per_page: 40}, succ(function (data) {
        data.meta.should.have.property('results_per_page', 40)
        data.meta.should.have.property('number_of_pages', 7) // TODO
        data.should.have.lengthOf(40)
      }))

      reg.departmentCourses('cis', {page_number: 2, results_per_page: 40}, succ(function (data) {
        data.meta.should.have.property('page_number', 2)
        data.meta.should.have.property('number_of_pages', 7) // TODO
        data.should.have.lengthOf(40)
      }))
    // })
  // })
// })





reg.departmentCourses('abc', err)
reg.departmentCourses('abc', err)
