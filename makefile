# Pages are written in html_src/*.ptml and built into the repo root.
# Includes without a slash (menu.txt, head.txt) come from TEMPLATE_DIR;
# includes with one (quizzes/quiz1.qhtm) are relative to the repo root.
export TEMPLATE_DIR = templates
UTIL_DIR = ./utils

SRCS = $(wildcard html_src/*.ptml)
HTMLFILES = $(patsubst html_src/%.ptml,%.html,$(SRCS))
INCS = $(TEMPLATE_DIR)/menu.txt $(TEMPLATE_DIR)/head.txt

%.html: html_src/%.ptml $(INCS)
	$(UTIL_DIR)/html_include.awk <$< >$@

local: quizzes $(HTMLFILES)

website: local
	-git commit -a -m "HTML rebuild."
	git push origin master

quizzes:
	cd quizzes ; make all test

clean:
	touch html_src/*.ptml
	cd quizzes ; make clean

.PHONY: local website quizzes clean
