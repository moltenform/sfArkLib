INSTALL?=install

OBJECTS=sfklCoding.o sfklDiff.o sfklLPC.o sfklZip.o sfklCrunch.o sfklFile.o sfklString.o

ENDIANNESS=LITTLE_ENDIAN

CXXFLAGS+=-fPIC -D__$(ENDIANNESS)__ -Wall -Wextra

OS := $(shell uname)
ifeq ($(OS),Darwin)
LDFLAGS += -flat_namespace -undefined suppress -dynamiclib
SO = dylib
else 
LDFLAGS += -shared
SO = so
INSTALL += -D
endif

all: libsfark.$(SO)

.PHONY: clean

clean:
	-rm *.o libsfark.$(SO)

test: libsfark.$(SO)
	-rm -rf sfarkxtc
	git clone https://github.com/raboof/sfarkxtc
	CXXFLAGS="-I.. -L.." make -C sfarkxtc
	rm -rf sfarkxtc

libsfark.$(SO): $(OBJECTS)
	$(CXX) -shared $(LDFLAGS) $(OBJECTS) -o libsfark.$(SO)

# It is unclear to me whether /usr/local/* is the proper location on
# OSX, as reportedly it's not on the clang path by default there. Let
# me know if you know how this should be done there :).
install: libsfark.$(SO) sfArkLib.h
	$(INSTALL) libsfark.$(SO) $(DESTDIR)/usr/local/lib/libsfark.$(SO)
	$(INSTALL) sfArkLib.h $(DESTDIR)/usr/local/include/sfArkLib.h
