import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "templateId", "rewardPoints", "photoPreview"]

  fill(event) {
    const button = event.currentTarget
    const { templateName, templatePhotoUrl, templateRewardPoints, templateId, templateIcon } = button.dataset

    this.nameTarget.value = templateName
    this.templateIdTarget.value = templateId

    if (templateRewardPoints) {
      this.rewardPointsTarget.value = templateRewardPoints
    }

    if (this.hasPhotoPreviewTarget && templatePhotoUrl) {
      this.photoPreviewTarget.src = templatePhotoUrl
      this.photoPreviewTarget.style.display = "block"
    }

    if (templateIcon) {
      const radio = this.element.querySelector(`input[type="radio"][name="reward[icon]"][value="${templateIcon}"]`)
      if (radio) radio.checked = true
    }
  }
}
