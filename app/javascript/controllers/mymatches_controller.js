import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mymatches"
export default class extends Controller {
  static targets = ["next", "previous"]
  connect() {
    console.log("Worked")
    this.add_arrows();
  }
  next(){
    console.log(this.element);
    this.element.classList.add("d-none");
    this.element.nextElementSibling.classList.remove("d-none");
  }

  previous(){
    this.element.classList.add("d-none");
    this.element.previousElementSibling.classList.remove("d-none");
  }
  add_arrows(){
    if (this.element.nextElementSibling) {
      this.nextTarget.classList.remove("d-none")
    }
    if (this.element.previousElementSibling){
      this.previousTarget.classList.remove("d-none")
    }
  }
}
