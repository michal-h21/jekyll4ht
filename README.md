the `jekyll4ht` package and script
==================================

This package simplifies creation of html files suitable for static site
generators, such as [Jekyll](http://jekyllrb.com/),
[Middleman](https://middlemanapp.com/) or
[Lettersmith](https://github.com/gordonbrander/lettersmith), from LaTeX
documents, using `tex4ht`. 

Instead of full html page, document with metadata in frontmatter in `YAML`
format and HTML content of `body` element is created. Documents in this form
can be used by static site generators to compile web sites and blogs. 



# `jekyll4ht` script

Variant of [make4ht](https://www.ctan.org/pkg/make4ht?lang=en) command is provided. It can 
automatically copy HTML, CSS and images to correct destinations in your static site project
directory.

The command is called `jekyll4ht`, the difference from `make4ht` is that it has
special mode, `publish`. In this mode, `jekyll` package is included automatically and all 
output files are copied to the correct locations in the static site (static
site generator must be called manually).  The command options are the same as
of `make4ht`. 

Command 

    jekyll4ht -uc sample.cfg filename

will create complete HTML document in the current directory

    jekyll4ht -uc sample.cfg -m publish filename

will create HTML file with YAML header and it will save it as
`YYYY-MM-DD-document-title.html` in the `posts` directory. All included and and
generated images will be saved in the `img` directory.

Generated filename is saved in `$input.published` file, it will be reused in
future compilations. If you want to change the post date, delete the generated
file in the static site and `$input.published`.

## Configuration

Because variety of static site generators are
supported, configuration file can be used to specify the locations where output
files should be put.

You can use default configuration suitable for `Jekyll` generator, only `JEKYLL4HT_BASE` environment
variable must be set. It should point to the root of your static site.

    export JEKYLL4HT_BASE=~/myblog

If you want to modify the configuration, the configuration file must be
provided. It should be named `.jekyll4ht`. It is looked up in the current
directory, all of its parents, `$XDG_CONFIG_HOME/jekyll4ht/.jekyll4ht` and
`$HOME/.jekyll4ht`. This enables you to have multiple static sites in your
computer.

Possible structure of your static site could be:

    $HOME
      blog
        root
          _site
          _posts
          css
          img
        texfiles
          .jekyll4ht
          first_post
            first_post.tex
          second_post
            second_post.tex


In this example, two directories are set up in the `blog` directory, `root`
where `jekyll` project is placed and `texfiles` with TeX source codes of the
posts. Particular posts are placed in subdirectories, they share configuration
file `.jekyll4ht` in the `texfiles` directory.

It's minimal contents may look this way:

    base = "~/blog/root/"

A configuration file is sandboxed LUA code, configuration values are saved in
global variables (without `local` keyword)

## Variables


    base = "" 
    posts = "./_posts"
    css  =  "./css"
    img  =  "./img"
    nametpl =  "${date}-${slug}.html"
    publish_mode = "publish"
    image_extensions = {"jpg","png","svg","gif"}
    excerpt_count = 1
    excerpt_pattern = '([%a%s%<%>%/]+</p>)'
    excerpt_separator = "\n<!--more-->\n"
    build_file = nil   -- don't use default build file

### Directories

`posts`, `css` and `img` directories should be specified relatively to the `base` dir. The default values should work for `Jekyll`.

### Publishing

`publish_mode` specifies `mode` option used for publishing.

`nametpl` can be used to change the post name, variables are specified as
`${var-name}`. Default value save the file with published date and sanitized
title. Original file name is available as `${input}`.

# `jekyll` package
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

Please note that it is not necessary to use `jekyll` package directly in your
document if you use `jekyll4ht` package, as it is included automaticaly when
the finished document is published. It is included in this example only to
illustrate the YAML configuration.

The metadata block is enclosed in `---` ... `---` section. Metadata are derived
automaticaly, although you can add new properties or change default values.
Each property is configurable using `\Configure{Jekyll.propertyname}{new
value}` in the `.cfg` file.

New properties are declared using `\Configure{JekyllDeclare}` and added to the
list of used properties with `\Configure{JekyllAddProperty}`

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
    
