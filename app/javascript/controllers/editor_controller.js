import { Controller } from "@hotwired/stimulus"

import { minimalSetup, EditorView } from "codemirror"
import { EditorState } from '@codemirror/state';
import { markdown } from "@codemirror/lang-markdown"
// Every mode in language-data is behind a dynamic import, so the build splits
// them into chunks that only load when a fenced block names that language.
import { languages } from "@codemirror/language-data"
import { oneDark } from "@codemirror/theme-one-dark"

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

  async togglePreview() {
    const preview = this.previewTarget;

    if (preview.style.display === "none") {
      preview.textContent = "rendering…";
      preview.style.display = "block";
      this.wrapperTarget.style.display = "none";
      preview.innerHTML = await this.renderMarkdown(this.editor.state.doc.toString());
    } else {
      preview.innerHTML = "";
      preview.style.display = "none";
      this.wrapperTarget.style.display = "block";
    }
  }

  // Rendered server-side so the preview is byte-identical to the saved note.
  async renderMarkdown(body) {
    const token = document.querySelector('meta[name="csrf-token"]')?.content;
    const response = await fetch("/preview", {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-CSRF-Token": token },
      body: JSON.stringify({ body }),
    });

    if (!response.ok) return "<p>preview failed</p>";

    return await response.text();
  }

  disconnect() {
    this.editor.destroy()
  }
}
