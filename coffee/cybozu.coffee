class Cybozu
  @refreshRate = 5 * 60 * 1000
  @positiveKeywordsRegexes = []
  @negativeKeywordsRegexes = []

  @defaultOptions:

  initialize: () ->
    refresh()


  refresh: () ->
    chrome.storage.sync.get null, (items) =>
      icon_list = $("#content-wrapper > div.contentPersonalAdmin > div > table > tbody > tr > td > table > tbody > tr:nth-child(2) > td > div > div > fieldset > div")
      link = "<a href=\"#\" class=\"adminButton\" style=\"width:8em\"><img src=\"https://static.cybozu.com/o/10.2.4.10-20150226/image/export32.png\" align=\"absmiddle\"><br>Import to Google<br>Calendar</a>"
      icon_list.append(link)
#      console.log icon_list

      button_list = $("#content-wrapper > div.contentPersonalAdmin > div > form > table > tbody > tr > td > table > tbody > tr:nth-child(2) > td > div > div.vr_formCommitWrapper > p")
      button = "<input type=\"button\" class=\"vr_stdButton\" name=\"Import\" value=\"Import to Google\" onclick=\"window.cybozu.importToGoogle();\">"

      button_list.append(button)

  importToGoogle: () ->
    console.log "import to google called"

  setFavicon: (count) ->
    favicon = $("link[type='image/x-icon']")
    if count
      chrome.runtime.sendMessage { message: "lgtm:update-favicon", count: count }, (response) ->
        favicon.prop "href", response.dataurl
    else
      favicon.prop "href", "https://assets-cdn.github.com/favicon.ico"


inject = $("<script>")
inject.prop("src", chrome.extension.getURL("js/pushstate.js"))
$("head").append(inject)

console.log "adding cybozu"
window.cybozu = new Cybozu()
console.log window.cybozu

$(() ->
  window.cybozu.refresh()
)

window.addEventListener "message", (event) ->
  if event.data.action == "cybozu:refresh"
    window.cybozu.refresh()
