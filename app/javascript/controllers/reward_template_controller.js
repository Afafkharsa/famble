import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "templateId", "rewardPoints", "photoPreview", "iconInput", "iconGrid"]

  fill(event) {
    const button = event.currentTarget
    const name = button.dataset.templateName
    const photoUrl = button.dataset.templatePhotoUrl
    const rewardPoints = button.dataset.templateRewardPoints
    const templateId = button.dataset.templateId
    const icon = button.dataset.templateIcon

    this.nameTarget.value = name
    this.templateIdTarget.value = templateId

    if (rewardPoints) {
      this.rewardPointsTarget.value = rewardPoints
    }

    if (photoUrl) {
      this.photoPreviewTarget.src = photoUrl
      this.photoPreviewTarget.style.display = "block"
    }

    if (icon && this.hasIconInputTarget) {
      this.iconInputTarget.value = icon
      this.iconGridTarget.querySelectorAll(".icon-option").forEach(btn => {
        btn.classList.toggle("icon-option--active", btn.dataset.icon === icon)
      })
    }
  }

  selectIcon(event) {
    const icon = event.currentTarget.dataset.icon
    this.iconInputTarget.value = icon
    this.iconGridTarget.querySelectorAll(".icon-option").forEach(btn => {
      btn.classList.toggle("icon-option--active", btn.dataset.icon === icon)
    })
  }
}
