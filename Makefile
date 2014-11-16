THUMBS = $(shell grep -ahro --exclude _new_post.sh --exclude Makefile --exclude *swp --exclude-dir _site --exclude-dir .git 'thumbs/[^ "]\+')
CV = cv.en.md cv.ru.md

all: cv $(THUMBS)
	jekyll --pygments

cv: $(CV)

cv.%.md: _cv.%.yml
	python3 _cv.py $<

thumbs/%: images/%
	convert $^ -thumbnail '200x200>' $@
	git add $^
	git add $@

.PHONY: server
server: all
	nohup jekyll --server &
