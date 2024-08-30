import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="accept-reject"
export default class extends Controller {
  static targets = ["status"]
  static values = {
    usermatch: Object
  }
  connect() {
    console.log("Hello!");
  }
  accept() {

    fetch(`acceptusermatch/${this.usermatchValue.id}`).then(response => response.json()).then(data => this.updateStatus(data));
  }
  reject() {
    fetch(`rejectusermatch/${this.usermatchValue.id}`).then(response => response.json()).then(data => this.updateStatus(data));
  }
  updateStatus(data){
    data = JSON.parse(data.message)
    console.log(data)
    if (data["status"] === "accepted"){
      this.statusTarget.removeAttribute('class');
      this.statusTarget.classList.add("text-success")
      this.statusTarget.innerHTML = data["status"]
    } else {
      this.statusTarget.removeAttribute('class');
      this.statusTarget.classList.add("text-warning")
      this.statusTarget.innerHTML = data["status"]
    }
  }
}
