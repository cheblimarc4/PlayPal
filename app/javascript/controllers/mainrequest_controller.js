import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mainrequest"
export default class extends Controller {
  static targets = ["your", "match"]
  connect() {
    console.log("connteceted")
  }

  showMyRequests(){
    this.yourTarget.classList.remove("d-none");
    this.matchTarget.classList.add("d-none");
  }
  showMyMatches(){
    this.yourTarget.classList.add("d-none");
    this.matchTarget.classList.remove("d-none");
  }
}
