$(document).on("pjax:end", function() {
  window.postMessage({ action: "cybozu:import" }, "*");
});

