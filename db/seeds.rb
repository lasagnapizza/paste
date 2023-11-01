body = %{# paste

paste is a simple markdown store, image pastebin but for markdown files, a few things to have in mind:

- you can create a paste, which is text in Markdown format, and it will be saved to a URL
- you can specify an edit password; otherwise, the system will provide you with one in order to edit the paste in the future
- if you forget the edit password, there is nothing you can do, just create a new note
- you can specify the URL slug; if not provided, the system will generate one for you
- content hosting is free, but it may be removed without notice in case of any infringement

paste supports most markdown features (GFM) and code highlight for multiple languages, just use regular markdown

send a message to contact@lasagna.pizza in case you need something (no password reset requests)
}
Note.create(body:, slug: "about", password: Note.random_password)
