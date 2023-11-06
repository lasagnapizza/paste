// app/javascript/controllers/html2haml_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'output'];

  connect() {
    this.inputTarget.focus();
  }

  selectAll(e) {
    e.target.focus();
    e.target.select();
  }

  async convert() {
    const inputHtml = this.inputTarget.value;

    if (this.inputTarget.value.length < 9) {
      this.outputTarget.value = "";
      return;
    }

    let response;
    try {
      response = await fetch('/html2haml', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          "X-CSRF-Token": this.getMetaValue("csrf-token")
        },
        body: JSON.stringify({ html: inputHtml })
      });
    } catch (error) {
      this.outputTarget.value = "";
      return;
    }

    if (response.ok) {
      const data = await response.json();
      this.outputTarget.value = data.haml;
    }
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element.getAttribute("content")
  }
}
