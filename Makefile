dirs := $(wildcard exercises/*)
all-tests := $(addprefix test-, $(notdir $(dirs)))

test: $(all-tests)

test-%:
	$(eval exercise := $(patsubst test-%, %, $@))	
	@echo "#  $(exercise)"
	@cd ./exercises/$(exercise) && cat test_$(exercise).sml | sed 's:$(exercise).sml:example.sml:' | poly -q
	@echo

.PHONY: test
