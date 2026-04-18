import { Controller } from "@hotwired/stimulus"

// Toggles visibility of a member column when the matching avatar chip is clicked.
// Pairs `data-member-filter-target="chip"` buttons with
// `data-member-filter-target="column"` wrappers by `data-member-id`.
export default class extends Controller {
  static targets = ["chip", "column"]

  toggle(event) {
    const chip = event.currentTarget
    const id = chip.dataset.memberId
    const column = this.columnTargets.find((c) => c.dataset.memberId === id)
    if (!column) return

    const hidden = column.classList.toggle("d-none")
    chip.classList.toggle("is-active", !hidden)
    chip.classList.toggle("opacity-50", hidden)
  }
}
