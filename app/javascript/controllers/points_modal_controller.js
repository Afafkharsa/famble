import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "modal", "avatar", "title", "subtitle",
    "amount", "reasonSelect", "reasonCustom", "reasonLabel",
    "submit", "error", "userIdField", "amountField", "reasonField", "form"
  ]

  static values = {
    addReasons: { type: Array, default: [] },
    removeReasons: { type: Array, default: [] }
  }

  connect() {
    this.currentType = null
    this.bsModal = window.bootstrap.Modal.getOrCreateInstance(this.modalTarget)
  }

  open(event) {
    const { userId, name, initials, photoUrl, color, type } = event.params
    this.currentType = type

    if (photoUrl) {
      this.avatarTarget.innerHTML = `<img src="${photoUrl}" class="w-100 h-100" style="object-fit: cover; border-radius: 50%;">`
      this.avatarTarget.style.background = "transparent"
    } else {
      this.avatarTarget.textContent = initials
      this.avatarTarget.style.background = color
    }
    this.userIdFieldTarget.value = userId
    this.amountTarget.value = 5
    this.reasonCustomTarget.value = ""
    this.errorTarget.classList.add("d-none")

    if (type === "remove") {
      this.titleTarget.textContent = "Deduct points"
      this.subtitleTarget.textContent = `from ${name}`
      this.submitTarget.textContent = "Deduct points"
      this.submitTarget.className = "btn btn-danger flex-grow-1 fw-bold"
      this.reasonLabelTarget.textContent = "Reason (required)"
      this.populateReasons(this.removeReasonsValue)
    } else {
      this.titleTarget.textContent = "Award points"
      this.subtitleTarget.textContent = `to ${name}`
      this.submitTarget.textContent = "Award points"
      this.submitTarget.className = "btn btn-success flex-grow-1 fw-bold"
      this.reasonLabelTarget.textContent = "Reason (optional)"
      this.populateReasons(this.addReasonsValue)
    }

    this.bsModal.show()
  }

  populateReasons(list) {
    const opts = ['<option value="">Pick a reason...</option>']
    list.forEach((r) => {
      const safe = r.replace(/"/g, "&quot;")
      opts.push(`<option value="${safe}">${safe}</option>`)
    })
    this.reasonSelectTarget.innerHTML = opts.join("")
    this.reasonSelectTarget.value = ""
  }

  close() {
    this.bsModal.hide()
    this.errorTarget.classList.add("d-none")
    this.currentType = null
  }

  numUp() {
    const n = parseInt(this.amountTarget.value, 10) || 0
    this.amountTarget.value = Math.min(99, n + 1)
  }

  numDown() {
    const n = parseInt(this.amountTarget.value, 10) || 0
    this.amountTarget.value = Math.max(1, n - 1)
  }

  selectChange() {
    this.reasonCustomTarget.value = ""
    this.errorTarget.classList.add("d-none")
  }

  customInput() {
    if (this.reasonCustomTarget.value.trim()) {
      this.reasonSelectTarget.value = ""
      this.errorTarget.classList.add("d-none")
    }
  }

  submit() {
    const amount = parseInt(this.amountTarget.value, 10) || 0
    if (amount <= 0) return

    const reason = this.reasonCustomTarget.value.trim() || this.reasonSelectTarget.value

    if (this.currentType === "remove" && !reason) {
      this.errorTarget.classList.remove("d-none")
      this.errorTarget.classList.add("d-block")
      return
    }

    const signed = this.currentType === "remove" ? -amount : amount
    this.amountFieldTarget.value = signed
    this.reasonFieldTarget.value = reason

    this.formTarget.requestSubmit()
  }
}
