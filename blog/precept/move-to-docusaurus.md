---
slug: move-to-docusaurus
title: Move from VuePress to Docusaurus
description: Experience of the process of moving existing markdown documentation from VuePress to Docusaurus 
authors: david
date: 2021-09-22
tags: [documentation, docusaurus, precept]
---

# VuePress to Docusaurus

I decided to move Precept's documentation from VuePress to Docusaurus.

I guess the first question would be - why move, what's wrong with VuePress?

In fairness, there is very little wrong with VuePress, but there are 2 things that Docusaurus provides 'out-of-the-box' that made the difference:

## Blog

VuePress does, I believe, have a Blog plugin, and I can't remember why I struggled with it.  Docusaurus does make it really simple though.


## Versioning

This was more of an issue for me.  I wanted to make sure I could keep control of multiple documentation versions, which is something that VuePress does not do without the use of a plugin.

The [VuePress versioning plugin](https://titanium-docs-devkit.netlify.app/guide/versioning.html) for it had some caveats which made me think it would be easier just to move to Docusaurus.


## The Transition

It could not be much simpler really:

1. Created a new source project, using the [Docusaurus Getting Started](https://docusaurus.io/docs) notes.
2. Copy the docs across.
3. [Add 'Dart'](#adding-dart) to the code block languages (Precept is a Flutter project)

## Publishing

I used [Vercel](https://vercel.com/) because it looked easy! It was.

**Updated 2021-10-12:**  It was easy to set up Vercel, but when the free trial for the Pro version ran out, I ran into problems trying to import as a personal project and went back to Netlify.  This was also straightforward, even though there are some cautionary notes the the Docusaurus documentation.

### Issues

I did have some broken links, but this seemed inconsistent - some worked, some did not.  

I did not spend any time diagnosing this, it was easier just to fix the links. Actually, the links were correct, but for some reason had to be re-entered for Docusaurus to recognise them.



## Adding Dart

In the docusaurus.config.js I modified the 'prism' section to read:

```javascript {2}
      prism: {
        additionalLanguages: ['dart'],
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
```