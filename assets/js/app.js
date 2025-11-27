// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import Alpine from 'alpinejs'
import Sortable from "../vendor/sortable"

import {SelectComponent} from "./select_component"
import {SelectManyComponent} from "./select_many_component"
import {FlashMessage} from "./flash_message"

window.Alpine = Alpine
Alpine.start()

let Hooks = {}
Hooks.SelectComponent = SelectComponent
Hooks.SelectManyComponent = SelectManyComponent
Hooks.Flash = FlashMessage

Hooks.StoreSettings = {
  // Called when a LiveView is mounted, if it includes an element that uses this hook
  mounted()
  {
    // Send a restore event to the LiveView
    // if nothing is stored yet, send a 'null' value    
    this.pushEvent("restore", {
      sorting: localStorage.getItem("sorting"),
      hide_done: localStorage.getItem("hide_done"),
    })
    
    this.handleEvent("saveConfigHide", ({ hide_done}) => 
      localStorage.setItem("hide_done", hide_done)
    )
    this.handleEvent("saveConfigSorting", ({sorting}) => 
      localStorage.setItem("sorting", sorting)
    )
  }
}


Hooks.Sortable = {
  mounted()
  {
    let group = this.el.dataset.group
    let sorter = new Sortable(this.el, {
      group: 'shared',
      animation: 150,
      dragClass: "drag-item",
      ghostClass: "drag-ghost",
      onEnd: e => {        
        let params = {old: e.from.id, new: e.to.id, item: e.item.id.split('-')[1]}
        this.pushEventTo(this.el, this.el.dataset["drop"] || "reposition", params)
      }
    })
  }
}





let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    hooks: Hooks,
    params: {_csrf_token: csrfToken},
    dom: {
      onBeforeElUpdated(from, to){
        if(from._x_dataStack){ window.Alpine.clone(from, to) }
      }
    }
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

