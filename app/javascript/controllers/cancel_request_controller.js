import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cancel-request"
export default class extends Controller {
  static targets = ["request"]
  static values = {
    usermatch: Object
  }
  remove() {
    this.element.remove();
    fetch(`cancelmymatch/${this.usermatchValue.id}`)
    .then(
      response => response.json()
    )
    .then( data => {
      let dom = document.querySelector("#showmessage")
      dom.classList.remove("d-none")
      dom.classList.add("alert-success")
      dom.innerHTML += "Request cancelled"
    })
  }
}
