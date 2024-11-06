// app/javascript/controllers/notification_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { status: String }

  connect() {
    this.applyStatusClass()
    setTimeout(() => {
      this.element.style.display = "none"
    }, 5000);
    // setTimeout(() => this.dismiss(), 5000) 
  }

  applyStatusClass() {
    const status = this.statusValue
    if (status === "success") {
      this.element.classList.add("bg-green-500")
    } else if (status === "error") {
      this.element.classList.add("bg-red-500")
    } else if (status === "warning") {
      this.element.classList.add("bg-orange-500")
    } else if (status === "info") {
      this.element.classList.add("bg-blue-500")
    }
  }

  dismiss() {
    this.element.remove()
  }
}

