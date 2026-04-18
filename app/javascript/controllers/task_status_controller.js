import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="task-status"
export default class extends Controller {
  static targets = ["approval"]
  static values = { id: Number, current: Boolean }

  toggle(event) {
    event.preventDefault()

    fetch(`/tasks/${this.idValue}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfToken,
        "Accept": "application/json"
      },
      body: JSON.stringify({ task: { status: !this.currentValue } })
    })
    .then(response => {
      if (!response.ok) throw response
      window.location.reload()
    })
    .catch(err => console.error("Task status toggle failed", err))
  }

  validate(event) {
    event.preventDefault()
    this.approvalTarget.disabled = true

    fetch(`/tasks/${this.idValue}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfToken,
        "Accept": "application/json"
      },
      body: JSON.stringify({ task: { validation: true } })
    })
    .then(response => {
      if (!response.ok) throw response
      window.location.reload()
    })
    .catch(err => {
      this.approvalTarget.disabled = false
      console.error("Validation failed", err)
    })
  }

  get csrfToken() {
    const meta = document.querySelector("meta[name='csrf-token']")
    return meta ? meta.content : ""
  }
}
