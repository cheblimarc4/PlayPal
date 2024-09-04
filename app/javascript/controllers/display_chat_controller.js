import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="display-chat"
export default class extends Controller {
  static targets = ["chatSection"]

  toggle() {
    // Access the chat section target and toggle visibility
     const chatSec = document.getElementById('chat-section');
    if (chatSec.classList.contains('hidden')) {
      // Show chat section
      chatSec.classList.remove('hidden');
      chatSec.scrollIntoView({ behavior: 'smooth' }); // Smooth scroll to the chat section
    } else {
      // Hide chat section if needed, or implement any other behavior
      chatSec.classList.add('hidden');
    }
  }
}
