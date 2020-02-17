var request = require("request");

var base_url = "http://localhost:3000/"

describe("Web Server Testing", function() {
  describe("GET /", function() {
    it("returns status code 500", function(done) {
      request.get(base_url, function(error, response, body) {
        expect(response.statusCode).toBe(500);
        done();
      });
    });
  });
});
