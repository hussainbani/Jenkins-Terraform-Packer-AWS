var request = require("request");

var base_url = "http://localhost:3000/"

describe("APP Server Testing", function() {
  describe("GET /", function() {
    it("returns status code 404", function(done) {
      request.get(base_url, function(error, response, body) {
        expect(response.statusCode).toBe(404);
        done();
      });
    });
  });
});
