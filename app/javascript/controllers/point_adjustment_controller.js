import { Controller } from "@hotwired/stimulus"

const ADD_REASONS = [
  "Helped without asking",
  "Was kind to sibling",
  "Did extra chores",
  "Good manners",
  "Great teamwork"
]

const DEDUCT_REASONS = [
  "Not kind to sibling",
  "Didn't do chores",
  "Talked back",
  "Screen time violation",
  "Didn't follow rules"
]

export default class extends Controller {
  static targets = [
    "modal", "avatar", "title", "subtitle",
    "kindInput", "memberIdInput",
    "amount", "reasonSelect", "reasonText",
    "submitBtn", "errorMsg"
  ]

  open(event) {
    const btn   = event.currentTarget
    const kind  = btn.dataset.kind
    const isAdd = kind === "add"

    this.kindInputTarget.value         = kind
    this.memberIdInputTarget.value     = btn.dataset.memberId
    this.avatarTarget.textContent      = btn.dataset.initials
    this.avatarTarget.style.background = btn.dataset.color
    this.titleTarget.textContent       = isAdd ? "Award points" : "Deduct points"
    this.subtitleTarget.textContent    = isAdd ? `to ${btn.dataset.name}` : `from ${btn.dataset.name}`

    this.amountTarget.value     = 5
    this.reasonTextTarget.value = ""
    this.errorMsgTarget.classList.add("d-none")

    const reasons = isAdd ? ADD_REASONS : DEDUCT_REASONS
    this.reasonSelectTarget.innerHTML =
      `<option value="">Pick a reason...</option>` +
      reasons.map(r => `<option value="${r}">${r}</option>`).join("")
    this.reasonSelectTarget.value = ""

    this.submitBtnTarget.textContent  = isAdd ? "Award points" : "Deduct points"
    this.submitBtnTarget.dataset.mode = kind

    new window.bootstrap.Modal(this.modalTarget).show()
  }

  step(event) {
    const val = parseInt(this.amountTarget.value) || 0
    this.amountTarget.value = Math.max(1, Math.min(99, val + parseInt(event.currentTarget.dataset.delta)))
  }

  clearSelect() {
    if (this.reasonTextTarget.value.trim()) this.reasonSelectTarget.value = ""
    this.errorMsgTarget.classList.add("d-none")
  }

  clearText() {
    if (this.reasonSelectTarget.value) this.reasonTextTarget.value = ""
    this.errorMsgTarget.classList.add("d-none")
  }

  submit(event) {
    event.preventDefault()
    const reason = this.reasonSelectTarget.value || this.reasonTextTarget.value.trim()
    if (this.kindInputTarget.value === "deduct" && !reason) {
      this.errorMsgTarget.classList.remove("d-none")
      return
    }
    if (!this.reasonTextTarget.value.trim()) this.reasonTextTarget.value = reason
    event.currentTarget.closest("form").requestSubmit()
  }
}
