THUMBS = $(shell grep -ahro --exclude Makefile --exclude *swp --exclude-dir _site 'thumbs/[^ ]\+')

all: $(THUMBS)
	jekyll build

thumbs/%: images/%
	convert $^ -thumbnail '200x200>' $@
	git add $@

.PHONY: server
server: all
	nohup jekyll serve --detach &
