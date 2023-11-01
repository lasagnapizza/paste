import { Controller } from "@hotwired/stimulus"

import { minimalSetup, EditorView } from "codemirror"
import { EditorState } from '@codemirror/state';
import { markdown } from "@codemirror/lang-markdown"
import { languages } from "@codemirror/language-data"
import { oneDark } from "@codemirror/theme-one-dark"

export default class extends Controller {
  static targets = ['editor']

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
    const view = new EditorView({
      state: startState,
      parent: textarea,
    });
    textarea.parentNode.insertBefore(view.dom, textarea);
    textarea.style.display = 'none';
    textarea.form.addEventListener('submit', (e) => {
      textarea.value = view.state.doc.toString();
      if (!textarea.value) e.preventDefault();
    });
  }
}
