import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "templateId", "rewardPoints", "photoPreview"]

  fill(event) {
    const button = event.currentTarget
    const name = button.dataset.templateName
    const photoUrl = button.dataset.templatePhotoUrl
    const rewardPoints = button.dataset.templateRewardPoints
    const templateId = button.dataset.templateId

    this.nameTarget.value = name
    this.templateIdTarget.value = templateId

    if (rewardPoints) {
      this.rewardPointsTarget.value = rewardPoints
    }

    if (photoUrl) {
      this.photoPreviewTarget.src = photoUrl
      this.photoPreviewTarget.style.display = "block"
    }
  }
}
