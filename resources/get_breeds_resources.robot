*** Settings ***
Library  RequestsLibrary
Library  Collections

*** Variables ***
${BASE_URL}  https://catfact.ninja
${ENDPOINT}  /breeds
${URL}       ${BASE_URL}${ENDPOINT}

*** Keywords ***
When I send a GET request to /breeds without specifying a limit parameter
  ${RESPONSE}=  GET  ${URL}
  Set Test Variable  ${RESPONSE}

Then I should receive a response with status code
  [Arguments]  ${status_code}  ${status_reason}
  Status Should Be  ${status_code}
  Should Be Equal As Strings  ${status_reason}  ${RESPONSE.reason}

And the response body should contain an array named "data" with a list of breeds
  Dictionary Should Contain Key  ${RESPONSE.json()}  data

And each breed in the list should have the following fields: breed, country, origin, coat, and pattern
  ${DATA}=  Get From Dictionary  ${RESPONSE.json()}  data
  FOR  ${ITEM}  IN  @{DATA}
    Should Contain  ${ITEM}  breed
    Should Contain  ${ITEM}  country
    Should Contain  ${ITEM}  origin
    Should Contain  ${ITEM}  coat
    Should Contain  ${ITEM}  pattern
  END

Given I specify the limit parameter
  [Arguments]  ${LIMIT_PARAMETER}
  ${URL}=  Evaluate  '${URL}?limit=${LIMIT_PARAMETER}'
  Set Test Variable  ${URL}

When I send a GET request to /breeds
  ${RESPONSE}=  GET  ${URL}
  Set Test Variable  ${RESPONSE}

And the response should include the error
  [Arguments]  ${EXPECTED_ERROR}
  Dictionary Should Contain Key  ${RESPONSE.json()}  error
  Should Be Equal As Strings  ${EXPECTED_ERROR}  ${RESPONSE.json()['error']}

And the response should include the message
  [Arguments]  ${EXPECTED_MESSAGE}
  Dictionary Should Contain Key  ${RESPONSE.json()}  message
  Should Be Equal As Strings  ${EXPECTED_MESSAGE}  ${RESPONSE.json()['message']}

And the response body should contain a "data" field
    ${DATA}=    Get From Dictionary    ${response.json()}    data
    Should Not Be Empty    ${DATA}

And the "data" field should contain exactly one object
  ${DATA}=  Get From Dictionary  ${RESPONSE.json()}  data
  FOR  ${ITEM}  IN  @{DATA}
    Should Be Equal As Strings  ${ITEM['breed']}  Abyssinian
    Should Be Equal As Strings  ${ITEM['country']}  Ethiopia
    Should Be Equal As Strings  ${ITEM['origin']}  Natural/Standard
    Should Be Equal As Strings  ${ITEM['coat']}  Short
    Should Be Equal As Strings  ${ITEM['pattern']}  Ticked
  END