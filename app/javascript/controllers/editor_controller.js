import { Controller } from "@hotwired/stimulus"

import { minimalSetup, EditorView } from "codemirror"
import { EditorState } from '@codemirror/state';
import { markdown } from "@codemirror/lang-markdown"
import { languages } from "@codemirror/language-data"
import { oneDark } from "@codemirror/theme-one-dark"
import { Converter } from "showdown";

export default class extends Controller {
  static targets = ['editor', 'preview', 'wrapper']

  connect() {
    const textarea = this.editorTarget;
    const startState = EditorState.create({
      doc: textarea.value,
      extensions: [
        minimalSetup,
        oneDark,
        EditorView.lineWrapping,
        markdown({ codeLanguages: languages })
      ]
    })
    this.editor = new EditorView({
      state: startState,
      parent: textarea,
    });
    textarea.parentNode.insertBefore(this.editor.dom, textarea);
    textarea.style.display = 'none';
    textarea.form.addEventListener('submit', (e) => {
      textarea.value = this.editor.state.doc.toString();
      if (!textarea.value) e.preventDefault();
    });
  }

  togglePreview() {
    const preview = this.previewTarget;

    if (preview.style.display === "none") {
      const converter = new Converter();
      const text = this.editor.state.doc.toString();
      preview.innerHTML = converter.makeHtml(text);
      preview.style.display = "block";
      this.wrapperTarget.style.display = "none";
    } else {
      preview.innerHTML = "";
      preview.style.display = "none";
      this.wrapperTarget.style.display = "block";
    }
  }

  disconnect() {
    this.editor.destroy()
  }
}
