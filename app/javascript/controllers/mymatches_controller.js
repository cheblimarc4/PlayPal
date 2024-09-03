import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mymatches"
export default class extends Controller {
  connect() {
    console.log("connected -mymatches controller");
  }
  next(){
    console.log(this.element);
    console.log(this.element.nextSibling)
  }
}
