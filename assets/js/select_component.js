export const SelectComponent = {
  mounted() {
    console.log("mount SelectComponent");
    this.el.addEventListener("selected-change", event => {
      this.pushEventTo(`#${event.detail.id}`, "update", event.detail)
    })

    this.handleEvent("close-selected", data => {
      const element = document.querySelector(`#${data.id}`)

      if (!element) return
      if (data.id != this.el.id) return

      element.dispatchEvent(new CustomEvent("reset"))

      this.el.querySelector('input[type=hidden]').value = data.value_id
      this.el.querySelector('input[type=hidden]').dispatchEvent(new Event("input", {bubbles: true}))
    })
  }
}