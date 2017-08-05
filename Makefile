dirs := $(wildcard exercises/*)
all-tests := $(addprefix test-, $(notdir $(dirs)))

test: $(all-tests)

ifdef TRAVIS_COMMIT_RANGE
COMMIT_RANGE := $(TRAVIS_COMMIT_RANGE)
else
COMMIT_RANGE := HEAD^1..HEAD
endif

travis:
	@echo COMMIT_RANGE: $(COMMIT_RANGE)
	@echo TRAVIS_COMMIT_RANGE: $(TRAVIS_COMMIT_RANGE)
	@echo TRAVIS_PULL_REQUEST: $(TRAVIS_PULL_REQUEST)
	@# run tests only if any exercise was added/edited
	@# what if one get removed?

	git diff-tree -r --name-only HEAD...master

	$(eval tests := $(shell git diff-tree --name-only -r $(COMMIT_RANGE) | perl -n -e '/exercises\/([a-z-_]+)\/.+\.sml/ && print "test-$$1\n"' | uniq))
	$(if $(tests), @$(MAKE) -s $(tests), @echo 'Nothing to test')

test-%:
	$(eval exercise := $(patsubst test-%, %, $@))
	@echo "# $(exercise) #"
	@echo
	@cd ./exercises/$(exercise) && cat test_$(exercise).sml | sed 's:$(exercise).sml:example.sml:' | poly -q
	@echo

.PHONY: test
