tex_content = $(wildcard *.sty) $(wildcard *.4ht) $(wildcard *.tex) 
project = jekyll4ht
lua_content = $(project) $(wildcard *.lua)
doc_file = ${project}-doc.pdf
TEXMFHOME = $(shell kpsewhich -var-value=TEXMFHOME)
TEX_DIR = $(TEXMFHOME)/tex/latex/$(project)
LUA_DIR = $(TEXMFHOME)/scripts/lua/${project}
INSTALL_DIR = $(LUA_DIR)
MANUAL_DIR = $(TEXMFHOME)/doc/latex/${project}
SYSTEM_DIR = /usr/local/bin
BUILD_DIR = build
BUILD_TEX4EBOOK = $(BUILD_DIR)/${project}/

all: doc

doc: $(doc_file) readme.tex

${project}-doc.pdf: ${project}-doc.tex readme.tex changelog.tex
	latexmk -lualatex ${project}-doc.tex

readme.tex: README.md
	pandoc -f markdown+definition_lists+inline_notes -t LaTeX README.md > readme.tex

changelog.tex: CHANGELOG.md
	pandoc -f markdown+definition_lists -t LaTeX CHANGELOG.md > changelog.tex

build: doc $(tex_content) $(lua_content)
	@rm -rf build
	@mkdir -p $(BUILD_TEX4EBOOK)
	@cp $(tex_content) $(lua_content)  $(doc_file) $(BUILD_TEX4EBOOK)
	@cp README.md $(BUILD_TEX4EBOOK)README
	cd $(BUILD_DIR) && zip -r ${project}.zip ${project}

install: doc $(tex_content) $(lua_content)
	mkdir -p $(TEX_DIR)
	mkdir -p $(MANUAL_DIR)
	mkdir -p $(LUA_DIR)
	cp $(tex_content) $(TEX_DIR)
	cp $(lua_content) $(LUA_DIR)
	cp $(doc_file) $(MANUAL_DIR)
	chmod +x $(INSTALL_DIR)/${project}
	sudo ln -s $(INSTALL_DIR)/${project} $(SYSTEM_DIR)/${project}

