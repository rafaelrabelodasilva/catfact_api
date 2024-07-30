*** Settings ***
Documentation  Validate the GET method on the /breeds endpoint
Resource  ../resources/get_breeds_resources.robot

*** Test Cases ***
CT01: Valid request to GET /breeds returns status code 200 and a list of breeds
  When I send a GET request to /breeds without specifying a limit parameter
  Then I should receive a response with status code  200  OK
  And the response body should contain an array named "data" with a list of breeds
  And each breed in the list should have the following fields: breed, country, origin, coat, and pattern

CT02: Request with invalid limit parameter returns status code 400 and an error message
  Given I specify the limit parameter  abc001
  When I send a GET request to /breeds
  Then I should receive a response with status code  400  Bad Request
  And the response should include the error  Invalid parameter
  And the response should include the message  Parameter 'abc001' is not valid, it should be an integer

CT03: Validate that specifying the limit parameter 1 returns only the first object in the list
  Given I specify the limit parameter  1
  When I send a GET request to /breeds
  Then I should receive a response with status code  200  OK
  And the response body should contain a "data" field
  And the "data" field should contain exactly one object