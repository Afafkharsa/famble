import { Controller } from "@hotwired/stimulus"

// Uses the browser's Web Speech API to transcribe what the user says
// into the message input. Supported in Chromium browsers + Safari.
// If unsupported, the mic button stays hidden.
export default class extends Controller {
  static targets = ["input", "button", "status"]

  connect() {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
    if (!SpeechRecognition) return  // button stays hidden (d-none)

    this.recognition = new SpeechRecognition()
    this.recognition.continuous = false
    this.recognition.interimResults = true
    this.recognition.lang = navigator.language || "en-US"

    this.recognition.onresult = (event) => {
      let transcript = ""
      for (const result of event.results) transcript += result[0].transcript
      this.inputTarget.value = transcript
    }

    this.recognition.onend   = () => this.setListening(false)
    this.recognition.onerror = () => this.setListening(false)

    this.buttonTarget.classList.remove("d-none")
    this.listening = false
  }

  toggle() {
    if (!this.recognition) return
    this.listening ? this.recognition.stop() : this.recognition.start()
    this.setListening(!this.listening)
  }

  setListening(on) {
    this.listening = on
    this.buttonTarget.classList.toggle("btn-danger",          on)
    this.buttonTarget.classList.toggle("btn-outline-secondary", !on)
    this.statusTarget.classList.toggle("d-none",              !on)
    const icon = this.buttonTarget.querySelector("i")
    if (icon) icon.className = on ? "bi bi-mic-fill" : "bi bi-mic"
  }
}
