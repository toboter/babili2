import { Controller } from "stimulus"


export default class extends Controller {
  connect() {
    console.log("Hello, Stimulus!", this.element)
    this.targets.find('searchButton').classList.add('sr-only')
  }

  toggle() {
    this.targets.find('burger').classList.toggle('is-active')
    this.targets.find('menu').classList.toggle('is-active')
  }
}