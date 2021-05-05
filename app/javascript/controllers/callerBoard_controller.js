// javascript/controllers/callerBoard_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['submit', 'payload', 'control']

  connect() {
    console.log("Hello Caller!")
  }

  call (){
    const call = event.target.id
    this.payloadTarget.value = `add ${call}`
    this.submitTarget.click()
  }

  clear (){
    const call = event.target.id
    this.payloadTarget.value = `del ${call}`
    this.submitTarget.click()
  }

  break (){
    this.controlTarget.value = "Break"
    this.submitTarget.click()
  }

  resume (){
    this.controlTarget.value = "Resume"
    this.submitTarget.click()
  }

  bingo (){
    this.controlTarget.value = "Bingo"
    this.submitTarget.click()
  }

  won (){
    this.controlTarget.value = "Won"
    this.submitTarget.click()
  }

  home (){
    location.assign("/games")
  }

  newGame (){
    console.log("new game")
    // not implemented yet
    // this.controlTarget.value = "New"
    // this.submitTarget.click()
  }



}
