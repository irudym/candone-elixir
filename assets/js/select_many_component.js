export const SelectManyComponent = {
  mounted() {
    this.el.addEventListener("selected-add", event => {
      this.pushEventTo(`#${event.detail.id}`, "update", event.detail)
    })

    this.el.addEventListener("selected-remove", event => {
      this.pushEventTo(`#${event.detail.id}`, "remove", event.detail)
    })

    this.handleEvent("close-selected", data => {

      const element = document.querySelector(`#${data.id}`)

      if (!element) return
      if (data.id != this.el.id) return

      // element.dispatchEvent(new CustomEvent("reset"))

      ids = data.value.map((value) => value.id)

      // this.el.querySelector('input[type=hidden]').value = ids.toString()
      // this.el.querySelector('input[type=hidden]').dispatchEvent(new Event("input", {bubbles: true}))
    })
  }
}