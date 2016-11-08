all: g13d pbm2lpbm

# FLAGS=$(CXXFLAGS) -DBOOST_LOG_DYN_LINK -std=c++0x

CXXFLAGS:=$(CXXFLAGS) -DBOOST_LOG_DYN_LINK -std=c++0x

LIBS=	-lusb-1.0 -lboost_program_options \
	 	-lboost_log    \
	 	-lboost_system -lpthread

SRC=$(wildcard *.cc)

helper.o: helper.cpp helper.hpp 

include $(SRC:.cc=.d)

%.d : %.cc Makefile
	$(CC) -M $(CXXFLAGS) $< > $@.tmp; \
        sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.tmp > $@; \
        rm -f $@.tmp




g13d: $(SRC:.cc=.o) helper.o
	g++ -std=c++0x -o g13d  $^ $(LIBS)\

pbm2lpbm: pbm2lpbm.c Makefile
	$(CXX) $(CXXFLAGS) -o $@ $<

package:
	rm -Rf g13-userspace
	mkdir g13-userspace
	cp g13.cc g13.h logo.h Makefile pbm2lpbm.c g13-userspace
	tar cjf g13-userspace.tbz2 g13-userspace
	rm -Rf g13-userspace

clean: 
	rm -f g13 pbm2lpbm $(SRC:.cc=.o) $(SRC:.cc=.d) helper.o

