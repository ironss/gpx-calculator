
testfiles=$(wildcard test/test-*)
tests=$(patsubst test/%, %, $(testfiles))

all: $(tests)

$(tests): 
	test/$@
	
test: $(testfiles)
	$(foreach f, $^, $f;)

.PHONY: test $(tests)

