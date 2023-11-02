import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'output'];

  connect() {
    this.inputTarget.focus();
  }

  convert() {
    try {
      this.outputTarget.value = atob(this.inputTarget.value);
    } catch {
      this.outputTarget.value = '';
    }
  }

  convertBack() {
    try {
      this.inputTarget.value = btoa(this.outputTarget.value);
    } catch {
      this.inputTarget.value = '';
    }
  }
}
