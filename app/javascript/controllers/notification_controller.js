// app/javascript/controllers/notification_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { status: String }

  connect() {
    this.applyStatusClass()
    setTimeout(() => {
      this.element.style.display = "none"
    }, 5000);
  }

  dismiss() {
    this.element.remove()
  }
}

