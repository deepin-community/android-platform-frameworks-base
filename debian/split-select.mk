NAME = split-select
SOURCES = \
          Abi.cpp \
          Grouper.cpp \
          Rule.cpp \
          RuleGenerator.cpp \
          SplitDescription.cpp \
          SplitSelector.cpp \
          Main.cpp \

SOURCES := $(foreach source, $(SOURCES), tools/split-select/$(source))
CPPFLAGS += -Itools \
            -Ilibs/androidfw/include \
            -I/usr/include/android \
            -D_DARWIN_UNLIMITED_STREAMS
CXXFLAGS += -std=gnu++17
LDFLAGS += -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -llog -lutils -Ldebian/out -landroidfw -laapt

build: $(SOURCES)
	mkdir --parents debian/out
	$(CXX) $^ -o debian/out/$(NAME) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)