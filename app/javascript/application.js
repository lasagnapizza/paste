// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import { minimalSetup, EditorView } from "codemirror"
import { EditorState } from '@codemirror/state';
import { markdown } from "@codemirror/lang-markdown"
import { languages } from "@codemirror/language-data"


// The Markdown parser will dynamically load parsers
// for code blocks, using @codemirror/language-data to
// look up the appropriate dynamic import.
document.addEventListener('DOMContentLoaded', function () {
  const textarea = document.querySelector('#note_body');
  const startState = EditorState.create({
    doc: textarea.value,
    extensions: [
      minimalSetup,
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
  if (textarea.form) {
    textarea.form.addEventListener('submit', () => {
      textarea.value = view.state.doc.toString();
    });
  }
}, false);
