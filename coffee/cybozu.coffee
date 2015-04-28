class Cybozu
  @refreshRate = 5 * 60 * 1000
  @positiveKeywordsRegexes = []
  @negativeKeywordsRegexes = []

  initialize: () ->
    refresh()

  refresh: () ->
    chrome.storage.sync.get null, (items) =>
      icon_list = $("#content-wrapper > div.contentPersonalAdmin > div > table > tbody > tr > td > table > tbody > tr:nth-child(2) > td > div > div > fieldset > div")
      link = "<a href=\"#\" class=\"adminButton\" style=\"width:8em\"><img src=\"https://static.cybozu.com/o/10.2.4.10-20150226/image/export32.png\" align=\"absmiddle\"><br>Import to Google<br>Calendar</a>"
      icon_list.append(link)
#      console.log icon_list

      button_list = $("#content-wrapper > div.contentPersonalAdmin > div > form > table > tbody > tr > td > table > tbody > tr:nth-child(2) > td > div > div.vr_formCommitWrapper > p")
      button = "<input type=\"button\" class=\"vr_stdButton\" name=\"Import\" value=\"Import to Google\" onclick='window.postMessage({ action: \"cybozu:import\" }, \"*\");'>"

      button_list.append(button)

  importToGoogle: () ->
    chrome.runtime.sendMessage { message: "cybozu:something", count: "5" }, (data) ->
      console.log data
    form = $("#content-wrapper > div.contentPersonalAdmin > div > form")
    formData = form.serialize() + "&Export=%E6%9B%B8%E3%81%8D%E5%87%BA%E3%81%99"
    url = "ag.cgi/schedule.csv"
    $.ajax(
      type: "POST",
      url: url,
      data: formData,
      success: (data) ->
        alert data
        results = Papa.parse data
        headers = results.data[0]
        chrome.runtime.sendMessage { message: "cybozu:import-calendar", data: data }, (response) ->
          console.log response

    )
    return false

  @clientId = "370442298553-1027sk5ib0e6h1s01j9k0tl8gs166k69.apps.googleusercontent.com"
  # "370442298553-0sd4gu24c5tbdhfvesi7ugjhvt0tfag3.apps.googleusercontent.com"
  @apiKey = "AIzaSyCuIZZa6nyhf_QIrjDNKQeQzgdnMvuDF34"
  @scopes = ["https://www.googleapis.com/auth/calendar"]

  initGapi: (gapi) ->
    console.log "initting gapi"
    console.log gapi
    gapi.auth.authorize({
      client_id: @clientId,
      scope: @scopes,
      immediate: true }, (result) ->
          console.log result
      )
    gapi.client.setApiKey(@apiKey);

  checkAuth2: () ->
#    window.gapi.client.setApiKey("AIzaSyCuIZZa6nyhf_QIrjDNKQeQzgdnMvuDF34")
    window.gapi.auth.authorize({
      client_id: window.cybozu.clientId,
      scope: scopes,
      immediate: true
      }, (result) ->
        console.log result
    )

window.cybozu = new Cybozu()

inject = $("<script>")
inject.prop("src", chrome.extension.getURL("js/pushstate.js"))
$("head").append(inject)

inject = $("<script>")
inject.prop("src", "https://apis.google.com/js/client.js?onload=window.cybozu.initGapi")
$("body").append(inject)

$(() ->
  window.cybozu.refresh()
#  window.cybozu.initGapi(window.gapi)
)

window.addEventListener "message", (event) ->
  if event.data.action == "cybozu:import"
    window.cybozu.importToGoogle()
