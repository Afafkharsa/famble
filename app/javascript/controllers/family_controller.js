import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="family"
export default class extends Controller {
  static targets = ["newWrapper", "input", "selectWrapper", "select"]

  connect() {
    // run once on connect to set initial state
    this.toggle()
    console.log("Hi from family controler")
  }

  toggle() {
    const checkbox = this.element.querySelector("#existing_family_checkbox")
    const exists = checkbox ? checkbox.checked : true

    // toggle visibility of family select wrapper
    if (this.hasSelectWrapperTarget) {
      this.selectWrapperTarget.style.display = exists ? "" : "none"
    }

    // toggle visibility of new family wrapper
    if (this.hasNewWrapperTarget) {
      this.newWrapperTarget.style.display = exists ? "none" : ""
    }

    // required attributes
    if (this.hasSelectTarget) {
      if (exists) this.selectTarget.setAttribute("required", "required")
      else this.selectTarget.removeAttribute("required")
    }

    if (this.hasInputTarget) {
      if (exists) {
        this.inputTarget.removeAttribute("required")
        this.inputTarget.value = ""
      } else {
        this.inputTarget.setAttribute("required", "required")
      }
    }
  }
}
