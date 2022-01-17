---
slug: docusaurus-duplicate-routes
title: WARNING Duplicate routes found!
description: Build failure due to file path naming
authors: david
date: 2022-01-17
tags: [documentation, docusaurus]
---

# WARNING Duplicate routes found!

Docusaurus version: 2.0.0-beta.14

After making some changes to my documentation structure I started getting an error from the Docusaurus build:

> [WARNING] Duplicate routes found!


This actually took a while to track down but the cause seems bizarrely simple:

I originally had a path:
 
> /docs/tutorial/brief.md

I decided to rename *brief.md* to *tutorial.md*, so the path became:

> /docs/tutorial/tutorial.md

This fails, as it seems Docusaurus cannot handle two elements of the path being the same.  In the end I renamed the directory to *tutorial-guide*.

A bit odd that one ...