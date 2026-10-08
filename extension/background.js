// A page cannot close the window it lives in; an extension can. Closing the
// only window ends this Chromium, and the netflixhd launcher, waiting on it,
// brings the TV home screen back.
chrome.runtime.onMessage.addListener((message, sender) => {
  if (message && message.type === 'netflixhd:close' && sender.tab) {
    chrome.windows.remove(sender.tab.windowId)
  }
})
