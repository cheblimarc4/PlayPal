import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="matches"
export default class extends Controller {
  static static = {match: Object}
  connect() {
    console.log(this.matchTarget);
  }
  request(){
    console.log(this.matchValue)
  }
}
