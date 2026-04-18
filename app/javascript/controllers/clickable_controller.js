import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clickable"
export default class extends Controller {
  static values = { url: String }

  go(event) {
    // Prevent redirect if clicking on a link or button inside
    if (event.target.closest("a, button")) return

    window.location = this.urlValue
  }
}
