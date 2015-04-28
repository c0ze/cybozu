chrome.runtime.onMessage.addListener (request, sender, response) ->
  if request.message == "cybozu:import-calendar"
    console.log request.count
    return count

class MyGapi
  @clientId = "370442298553-0sd4gu24c5tbdhfvesi7ugjhvt0tfag3.apps.googleusercontent.com"
  @apiKey = "AIzaSyCuIZZa6nyhf_QIrjDNKQeQzgdnMvuDF34"
  @scopes = "https://www.googleapis.com/auth/plus.me"

  initGapi: (gapi) ->
    console.log "initting gapi"
    gapi.auth.authorize({
      client_id: @clientId,
      scope: @scopes,
      immediate: true }, (result) ->
        console.log result
    )
    gapi.client.setApiKey(@apiKey)

console.log gapi
# myGapi = new MyGapi()
# myGapi.initGapi(gapi)
