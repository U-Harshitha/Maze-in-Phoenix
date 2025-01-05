let Hooks = {}

Hooks.VideoHook = {
  mounted() {
    this.el.addEventListener('ended', () => {
      this.pushEvent("video_ended", {})
    })
  }
}

export default Hooks