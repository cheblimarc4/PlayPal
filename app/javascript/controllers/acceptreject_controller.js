import { Controller } from "@hotwired/stimulus"


// Connects to data-controller="accept-reject"
export default class extends Controller {
  static targets = ["confirm"]
  static values = {
    usermatch: Object,
    matchid:String,
    profilepic:String,
    classicon: String,
    defaultprofile: String

  }
  connect(){
    console.log("this is the default image");
    console.log(this.defaultprofileValue);
    console.log(this.profilepicValue);
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
    console.log(data);
    if (data.message["status"] === "denied") {
      this.confirmTarget.classList.add("d-none");
      this.element.remove();
      this.subtractPending()
    }
    if (data.message["status"] === "accepted"){
      this.swapAvatar(data.message.team)
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

  swapAvatar(team){
    console.log(team)
    const spot = document.getElementById(`${this.matchidValue}_playershow`)
    if (team == 'teamA') {
      if (spot.querySelector(".team_a_available_spots") == null){
        spot.querySelector(".team_b_available_spots").setAttribute("src", this.defaultprofileValue );
        spot.querySelector(".team_a_spot").setAttribute("src", this.profilepicValue);
      } else {

        const take = spot.querySelector(".team_a_available_spots")
        take.setAttribute("src", this.profilepicValue)
        take.classList.remove("team_a_available_spots")

      }

    } else {
      if (spot.querySelector(".team_b_available_spots") == null) {
        spot.querySelector(".team_a_available_spots").setAttribute("src", this.defaultprofileValue );
        spot.querySelector(".team_b_spot").setAttribute("src", this.profilepicValue);
      } else {
        const take = spot.querySelector(".team_b_available_spots")
        take.setAttribute("src", this.profilepicValue)
        take.classList.remove("team_b_available_spots")
      }
      console.log("added pic to team b")
    }
  }

  teamFull() {
      const contentdiv = document.getElementById(`${this.matchidValue}_contentdiv`);
      const match_full = `<div class="d-flex justify-content-center flex-column align-items-center" style="height:100%;width:100%;">
                      <div><h2 class="d-flex align-items-center">Your team is full<i class=${this.classiconValue}></i></h2></div>
                      <br><a class="join-btn m-0" href=/matches/${this.matchidValue}">Match Details</a>
                      </div>`;
      contentdiv.innerHTML = match_full;
      this.contantMatchReady();
  }
  contantMatchReady(){
    fetch(`matches/${this.matchidValue}/ready`);
    document.getElementById(`${this.matchidValue}_readystatus`).classList.remove("d-none");
    const matchdetailbutton = document.getElementById(`${this.matchidValue}_matchdetails`)
    matchdetailbutton.classList.add("d-none");
    matchdetailbutton.classList.remove("d-flex");
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
