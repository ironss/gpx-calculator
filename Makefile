
testfiles=$(wildcard test/test-*)
tests=$(patsubst test/%, %, $(testfiles))

all: $(tests)

$(tests): 
	TZ=NZST-12 test/$@
	
test: $(testfiles)
	$(foreach f, $^, $f &&) echo > /dev/null

.PHONY: test $(tests)


clean:
	rm -f test_*.xml
.PHONY: clean

