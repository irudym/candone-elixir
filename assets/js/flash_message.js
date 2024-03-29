export const FlashMessage = {

  mounted() {
    this.initFlash();
  },
  
  updated() {
    this.initFlash();
  },

  initFlash() {
    const flash = this.el.querySelector('.flash');

    if (flash) {
      setTimeout(() => {
        this.pushEvent('lv:clear-flash');
      }, 2000);
    }
  },
};