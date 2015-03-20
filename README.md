the `jekyll4ht` package
=======================

This package simplifies creation of html files suitable for static site
generators, such as [Jekyll](http://jekyllrb.com/),
[Middleman](https://middlemanapp.com/) or
[Lettersmith](https://github.com/gordonbrander/lettersmith), from LaTeX
documents, using `tex4ht`. 

Instead of full html page, document with metadata in frontmatter in `YAML`
format and HTML content of `body` element is created. Documents in this form are used by static site generators to compile web sites and blogs. 

## Example document:

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
    author: 
    --- 
    Hello world from <span class="obeylines-h"><span class="verb"><span 
    class="ectt-1000">Jekyll4ht</span></span></span>

metadata block is enclosed in `---` ... `---` section. Metadata are derived
automaticaly, although you can add new properties or change default values.
Each property is configurable using `\Configure{Jekyll.propertyname}{new
value}` in the `.cfg` file.

New properties are declared using `\Configure{JekyllDeclare}` and added to the list of used properties with `\Configure{JekyllAddProperty}`

Example: `hello.cfg`:

    \Preamble{xhtml}
    % Redefine date
    \Configure{Jekyll.date}{2015-03-16}
    % Declare property hello
    \Configure{JekyllDeclare}{hello}{\JekyllPrintString}{default value}
    \Configure{Jekyll.hello}{world}
    \Configure{JekyllAddProperty}{hello}
    \begin{document}%
    \EndPreamble%

(note that `%` after `\begin{document}` is important, you would get trailing
space otherwise, resulting in invalid YAML frontmatter)

`\Configure{JekyllDeclare}` takes three parameters: property name, print
function and default value, which may be string, or command. Only string
function available is `\JekyllPrintString` at the moment, but in the future
more functions may be added, for blocks or arrays, for example.

Resulting HTML:

    --- 
    title: Hello world 
    style: sample.css 
    layout: post 
    language: cs-CZ 
    date: 2015-03-16 
    author:  
    hello: world 
    --- 
    Hello world from <span class="obeylines-h"><span class="verb"><span 
    class="ectt-1000">Jekyll4ht</span></span></span>
    
    
