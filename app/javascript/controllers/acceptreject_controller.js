import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="accept-reject"
export default class extends Controller {
  static targets = ["status", "confirm"]
  static values = {
    usermatch: Object,
    matchid:String
  }
  connect(){
    console.log("Connected to AcceptReject");
  }
  accept() {
    fetch(`acceptusermatch/${this.usermatchValue.id}`).then(response => response.json()).then(data => this.updateStatus(data));
  }

  confirmReject(){
    this.confirmTarget.classList.remove("d-none");
  }

  cancelReject(){
    this.confirmTarget.classList.add("d-none");
  }

  reject() {
    fetch(`rejectusermatch/${this.usermatchValue.id}`).then(response => response.json()).then(data => this.updateStatus(data));
  }
  updateStatus(data){
    if (data.message["status"] === "denied") {
      this.confirmTarget.classList.add("d-none");
      this.element.remove();
      this.subtractPending()
    }
    if (data.message["status"] === "accepted"){
      this.subtractPending();
      const addTo = document.getElementById(`${this.matchidValue}_acceptedtotal`)
      addTo.innerHTML = `${parseInt(addTo.innerHTML, 10) + 1} / `;
      const totalDoc = document.getElementById(`${this.matchidValue}_totalNeeded`)
      if (parseInt(addTo.innerHTML, 10) == parseInt(totalDoc.innerHTML, 10)){
        this.teamFull()
      }
      this.element.remove();
    }
  }

  teamFull(){
      const contentdiv = document.getElementById(`${this.matchidValue}_contentdiv`);
      contentdiv.innerHTML = `<h1 class="text-center mb-4" style="font-size:35px; font-family:$headers-font">Your team is full</h1>`;
      this.contantMatchReady();
  }

  contantMatchReady(){
    fetch(`matches/${this.matchidValue}/ready`);
  }

  subtractPending(){
    const docID = `${this.matchidValue.toString()}_pendingtotal`;  // Use the corrected ID format
    const doc = document.getElementById(docID);

    if (doc) {  // Check if the element exists
        console.log('Found element:', doc);  // Debugging
        doc.innerHTML = parseInt(doc.innerHTML, 10) - 1;  // Decrement count
        if (doc.innerHTML == "0") {
          const contentdiv = document.getElementById(`${this.matchidValue}_contentdiv`);
          contentdiv.innerHTML = `<h1 class="text-center mb-4" style="font-size:35px; font-family:$headers-font">No more requests</h1>`;
        }
    } else {
        console.error(`Element with ID ${docID} not found.`);  // Log error if not found
    }
  }
}
