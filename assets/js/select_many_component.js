export const SelectManyComponent = {
  mounted() {

    
    
    this.handleEvent("update_input", data => {
      const element = document.querySelector(`#${data.id}`);

      if (!element) return;
      if (data.id != this.el.id) return;
      ids = data.value;


      this.el.querySelector('#' + data.input_id).value = ids.toString();
      // this.el.querySelector('input[type=hidden]').dispatchEvent(new Event("input", {bubbles: true}))
    });
  }
}