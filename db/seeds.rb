body = %{![paste logo i guess](/social-preview-image.png)

**paste** is a **simple markdown store**, like pastebin but it **renders as markdown**.

- create notes using Markdown, when published it will be rendered
- notes can be protected with a password, one will be generated if not set
- notes can have a custom URL slug, one will be generated if not set
- hosting is free, but it may be removed without notice in case of any infringement
- app is open source check it out at [github.com/lasagnapizza/paste](https;//github.com/lasagnapizza/paste)

> paste supports most markdown features (GFM) and `code` highlight for multiple languages, here is an [example note](/example)

send me message to paste@lasagna.pizza in case you need something (no password reset requests)

use responsibly
}
Note.create(body:, slug: "about", password: Note.random_password)

body = %{# Heading 1

## Heading 2

### Heading 3

#### Heading 4

##### Heading 5

###### Heading 6

Paragraphs are separated by a blank line.

*Italic text* or _Italic text_

**Bold text** or __Bold text__

***Bold and italic text*** or ___Bold and italic text___

1. Ordered list item 1
2. Ordered list item 2
3. Ordered list item 3

- Unordered list item 1
- Unordered list item 2
- Unordered list item 3

[Link text](https://paste.lasagna.pizza)

![Alt text for an image](https://paste.lasagna.pizza/social-preview-image.png)

> Blockquote

Inline `code`

    ```
    Code block with triple backticks
    ```

| Table header 1 | Table header 2 |
| -------------- | -------------- |
| Row 1, Cell 1  | Row 1, Cell 2  |
| Row 2, Cell 1  | Row 2, Cell 2  |

~~Strikethrough~~

Horizontal rule:

---
}
Note.create(body:, slug: "example", password: "nice")
