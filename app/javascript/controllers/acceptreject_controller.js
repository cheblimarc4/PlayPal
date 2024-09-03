import { Controller } from "@hotwired/stimulus"


// Connects to data-controller="accept-reject"
export default class extends Controller {
  static targets = ["confirm"]
  static values = {
    usermatch: Object,
    matchid:String,
    profilepic:String

  }
  connect(){
    console.log("Connected to AcceptReject");
    console.log(this.profilepicValue)
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
        spot.querySelector(".team_b_available_spots").setAttribute("src", "https://www.floridapublicmedia.org/wp-content/uploads/2017/03/explorer.png")
        const parent = spot.querySelector(".team_a_spot").parentElement;
        spot.querySelector(".team_a_spot").remove();
        parent.innerHTML = this.profilepicValue;
      } else {

        const parent = spot.querySelector(".team_a_available_spots").parentElement
        spot.querySelector(".team_a_available_spots").remove();
        parent.innerHTML = this.profilepicValue;
      }

    } else {
      if (spot.querySelector(".team_b_available_spots") == null) {
        spot.querySelector(".team_a_available_spots").setAttribute("src", "https://www.floridapublicmedia.org/wp-content/uploads/2017/03/explorer.png")
        const parent = spot.querySelector(".team_b_spot").parentElement;
        spot.querySelector(".team_b_spot").remove();
        parent.innerHTML = this.profilepicValue;
      } else {

        const parent = spot.querySelector(".team_b_available_spots").parentElement
        spot.querySelector(".team_b_available_spots").remove();
        parent.innerHTML = this.profilepicValue;

      }
      console.log("added pic to team b")
    }
  }

  teamFull() {
      const contentdiv = document.getElementById(`${this.matchidValue}_contentdiv`);
      const match_full = `<div class="d-flex justify-content-center align-items-center" style="height:100%;width:100%;">
                      <h2 class="d-flex align-items-center">Your team is full<i class="px-3 <%= match.sport_icon %> fs-3 bounce2"></i></h2>
                    </div>`;
      contentdiv.innerHTML = match_full;
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
