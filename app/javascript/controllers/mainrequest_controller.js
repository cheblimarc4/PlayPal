import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mainrequest"
export default class extends Controller {
  static targets = ["your", "users"]
  connect() {
    console.log("connteceted")
  }

  both(){
    this.yourTarget.classList.remove("d-none");
    this.usersTarget.classList.remove("d-none");
  }
  your(){
    this.yourTarget.classList.remove("d-none");
    this.usersTarget.classList.add("d-none");
  }
  users(){
    this.yourTarget.classList.add("d-none");
    this.usersTarget.classList.remove("d-none");
  }
}
