THUMBS = $(shell grep -ahro --exclude post.sh --exclude Makefile --exclude *swp --exclude-dir _site --exclude-dir .git 'thumbs/[^ ]\+')

all: $(THUMBS)
	jekyll --pygments

thumbs/%: images/%
	convert $^ -thumbnail '200x200>' $@
	git add $^
	git add $@

.PHONY: server
server: all
	nohup jekyll --server &
