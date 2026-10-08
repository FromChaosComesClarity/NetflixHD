// The way out, from the keyboard.
//
// Netflix already owns Escape and Backspace — both mean "back" — so leaving
// needs a key it does not use: Home, the key a TV remote has for exactly this,
// and Ctrl+Q as the desktop habit. Captured before the page sees it, so the
// site cannot swallow it.
window.addEventListener('keydown', event => {
  const home = event.key === 'Home' && !event.ctrlKey && !event.altKey && !event.metaKey
  const quit = event.ctrlKey && !event.altKey && (event.key === 'q' || event.key === 'Q')
  if (!home && !quit) return
  event.preventDefault()
  event.stopImmediatePropagation()
  chrome.runtime.sendMessage({ type: 'netflixhd:close' })
}, true)
