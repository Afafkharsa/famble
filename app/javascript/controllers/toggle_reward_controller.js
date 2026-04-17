import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-reward"
export default class extends Controller {

  connect() {
  }

  call(event) {
    event.preventDefault()

    console.log("toggle reward !!")

    if (event.currentTarget.classList.contains("d-none")) {
      event.currentTarget.classList.remove("d-none")
    } else {
      event.currentTarget.classList.add("d-none")
    }
  }
}
