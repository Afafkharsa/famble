import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "messages"]

  toggle() {
    this.panelTarget.classList.toggle("d-none")
    if (!this.panelTarget.classList.contains("d-none")) {
      this.scrollToBottom()
    }
  }

  close() {
    this.panelTarget.classList.add("d-none")
  }

  scrollToBottom() {
    if (!this.hasMessagesTarget) return
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
