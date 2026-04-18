import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  fill(event) {
    const card = event.currentTarget
    const { templateName, templateDescription, templateTaskPoints } = card.dataset

    const nameInput = this.element.querySelector('input[name="task[name]"]')
    const descInput = this.element.querySelector('textarea[name="task[description]"], input[name="task[description]"]')
    const pointsInput = this.element.querySelector('select[name="task[task_points]"], input[name="task[task_points]"]')

    if (nameInput && templateName) nameInput.value = templateName
    if (descInput && templateDescription) descInput.value = templateDescription
    if (pointsInput && templateTaskPoints) pointsInput.value = templateTaskPoints
  }
}
