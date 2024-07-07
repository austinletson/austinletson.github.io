---
title: "Thinking in Letters: Why Word Processors are Anti-words"
date: "2020-03-05" 
draft: false 
tags : [
    "editors",
    "vim",
    "google-docs",
    "microsoft-word",
]
categories : [
    "editors",
]
---

> “To the man who only has a hammer, everything he encounters begins to look like a nail.”
― Abraham Maslow 

Word processors have monopolized the domain of text composition for the last quarter century. At their core, these programs involve text entry at the cursor, but with this function come a peripheral of features: formatting, grammar and spell checking, support for annotation. However, the essential functionality is simple: move the cursor with the mouse or the arrow keys and type or delete letters at the cursor. Although some word processors promise features which approach a publishing suite, the average use case is the simple entry and manipulation of text. Because this functionality is so important, it is instructive to examine the interface a program provides for entry and deletion. 

![Microsoft Word](/img/officexp_clippy.png)

For the sake of argument I am going to focus on Google Docs. I Docs is a largely superior word processor to Microsoft Word and I don't want to punch down. The largest unit of text that Google Docs understands is a sentence. How does does Docs leverage this understanding? For the most part, sophisticated spelling and grammar checking tools. However, where Docs fails is the user interaction with the text. Word processors force the brain to descend to the level of the character while manipulating the document. Language is only reductively defined by characters. We are all authors and we think in words and sentences.

However we are not lost! There is a great tradition of editors which champion interfaces close to human understanding of text. Since the inception of the personal computer, programmers have stretched the conceptual bounds of editing and aggressively extended the tools they created.

The tool which we will examine today is Vim. Vim is an idiosyncratic editor which focuses on efficient text editing and extensibility. Vim users use the keyboard to move the cursor around the document and make changes to the text. These commands rarely focus on a single character manipulation but rather provide an arsenal of tools for the author to address the document on their own terms. 

![Vim](/img/vim-5-1.png)

Take this passage as an example:

> “The killer was wearing a blue ski mask. We'll never catch him now," said Liam. He held his face in his hands.  

> “Not on my watch,” answered Sheila. 

Say an author wants to delete the sentence after Liam's dialogue. From the beginning of the line, the author can press **)** to move forward a sentence and then press the input **das** (Delete Around Sentence) to delete the sentence. In Google Docs, the author must arbitrarily  select the text with the mouse and use the backspace to perform the same action. At first these inputs may seem similar, however Vim's syntax reflects the underling structure and meaning of the text and reflects the author's specific intention while editing. 

Next the author wants to change Sheila's dialogue to avoid cliché. After pressing **j** to move to the next line, the input **di"** (Delete In Quote) will delete the contents of the quote but not the quotation marks. Vim understands the difference between the contents of the quote and the full clause. This distinction is subtle but defines an important difference in the authors intention.

Now what is the meaning behind the syntax of these inputs? Vim commands consist of nouns and verbs. Nouns are logical text objects which represent well-defined text strings in a document. For instance a word is a text object (characters enclosed by two spaces), a quotation is a text object (a set of words enclosed in quotation marks). There are also text objects for sentences and paragraphs. The Vim community constantly adds novel text objects to Vim. You can install plugins that support many parts of English syntax and even define your own. An example of a complex text object is a subordinate clause, defined by the text between a subordinate conjunction and a period or comma. I am not aware if this text object exists in Vim but because Vim is entirely extensible you could easily add such a text object.


![Text Object](/img/vim-text-objects-commands.jpg)

In order to tap the immense power of text objects we will combine them with Vim verbs also known as operators. Operators describe actions to perform on a text object. Deletion, indenting, and changing case are examples of operators. A more powerful example is the ability to surround a text object with an arbitrary character. 

The power comes from composing verbs and nouns to make precise and sophisticated changes. Below are several increasingly powerful examples.

You can compose the operator **d** for delete and the text object **w** for word as **dw** to delete word at your cursor.

To delete the contents of a quotation you can compose delete and the quotation text object **di"**. This command will leave the quotation. If you want to delete the quotation and the quotation marks you can compose **da"**.

Almost all documents in 2020 are composed at our fingertips on a keyboard. This process should be a skill to hone and improve throughout life. All authors should strive to become one with the editor. Sadly the ceiling for document composition and editing in common tools such as Microsoft Word and Google Docs limit author's connection to the text. Vim provides an expressive tool set to compose and edit documents in plain text and an interface for community members to extend its functionality.  

Notes:

* There are some simplifications I have made in an effort to avoid over explaining Vim's features. The reader will find that in practice Vim is far more powerful than this article can articulate. I urge the reader to try Vim. There are plenty of stellar online resources to get started. 

* And for the sake of completeness and for those worried about the lack of formatting features in Vim, I should add that there exist many plain text formatting tools which support everything from font changes to sophisticated reader-facing formatting. 


* Image source: https://www.barbarianmeetscoding.com/