
testfiles=$(wildcard test/test-*)
tests=$(patsubst test/%, %, $(testfiles))

all: $(tests)

$(tests): 
	TZ=NZST-12 test/$@
	
test: $(testfiles)
	$(foreach f, $^, $f;)

.PHONY: test $(tests)

