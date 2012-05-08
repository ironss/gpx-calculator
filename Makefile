all: test

test: test/test-*
	$(foreach f, $^, sh -c $f;)
	

.PHONY: test

