the `jekyll4ht` package
=======================

This package simplifies creation of html files suitable for static site
generators, such as [Jekyll](http://jekyllrb.com/),
[Middleman](https://middlemanapp.com/) or
[Lettersmith](https://github.com/gordonbrander/lettersmith), from LaTeX
documents, using `tex4ht`. 

Instead of full html page, document with metadata in frontmatter in `YAML`
format and HTML content of `body` element is created. Documents in this form are used by static site generators to compile web sites and blogs. 

Example document:

    \documentclass{article}
    \usepackage{jekyll}
    \usepackage[T1]{fontenc}
    \usepackage[utf8]{inputenc}
    \usepackage[czech]{babel}
    \title{Hello world}
    \begin{document}
    Hello world from \verb|Jekyll4ht|
    \end{document}

produces:

    --- 
    title: Hello world 
    style: sample.css 
    layout: post 
    language: cs-CZ 
    date: 2015-03-18 
    --- 
    Hello world from <span class="obeylines-h"><span class="verb"><span 
    class="ectt-1000">Jekyll4ht</span></span></span>

metadata block is enclosed in `---` ... `---` section. Metadata are derived
automaticaly, although you can add new properties or change default values.

