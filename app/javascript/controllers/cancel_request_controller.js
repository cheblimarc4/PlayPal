import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cancel-request"
export default class extends Controller {
  static targets = ["request"]
  static values = {
    usermatch: Object
  }
  remove() {
    this.element.remove();
    fetch(`cancelmymatch/${this.usermatchValue.id}`).then(response => response.json()).then(data => console.log(data))
  }
}
