import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="task-status"
export default class extends Controller {
  static targets = ["todo","done","approved"]
  static values = { id: Number }

  connect() {
    console.log("Hello from task_status_controller.js")
  }

  complete(event) {
    event.preventDefault()
    const confirmMessage = this.element.dataset.turboConfirm
    if (confirmMessage && !confirm(confirmMessage)) return

    const url = `/tasks/${this.idValue}`
    const tokenMeta = document.querySelector("meta[name='csrf-token']")
    const token = tokenMeta ? tokenMeta.content : ""

    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        "Accept": "application/json"
      },
      body: JSON.stringify({ task: { status: true } })
    })
    .then(response => {
      if (!response.ok) throw response
      return response.json()
    })
    .then(data => {
      this.todoTarget.classList.add("d-none");
      this.doneTarget.classList.remove("d-none");
    })
    .catch(async err => {
      console.error("Task status update failed")
      try {
        const body = await err.json()
        console.error(body)
      } catch(_) {}
    })
  }

  validate(event) {
    event.preventDefault()
    const confirmMessage = this.element.dataset.turboConfirm
    if (confirmMessage && !confirm(confirmMessage)) return

    this.doneTarget.disabled = true

    const url = `/tasks/${this.idValue}`
    const tokenMeta = document.querySelector("meta[name='csrf-token']")
    const token = tokenMeta ? tokenMeta.content : ""

    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        "Accept": "application/json"
      },
      body: JSON.stringify({ task: { validation: true } })
    })
    .then(response => {
      if (!response.ok) throw response
      return response.json()
    })
    .then(data => {
      this.doneTarget.classList.add("d-none");
      this.approvedTarget.classList.remove("d-none");
    })
    .catch(async err => {
      this.doneTarget.disabled = false
      console.error("Validation failed")
      try {
        const body = await err.json()
        console.error(body)
      } catch(_) {}
    })
  }
}
