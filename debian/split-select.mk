NAME = split-select

# tools/split-select/Android.bp
SOURCES = \
  Abi.cpp \
  Grouper.cpp \
  Rule.cpp \
  RuleGenerator.cpp \
  SplitDescription.cpp \
  SplitSelector.cpp \
  Main.cpp \

SOURCES := $(foreach source, $(SOURCES), tools/split-select/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CPPFLAGS += \
  -D_DARWIN_UNLIMITED_STREAMS \
  -Ilibs/androidfw/include \
  -Itools \

LDFLAGS += \
  -Ldebian/out \
  -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -laapt \
  -landroidfw \
  -llog \
  -lutils \
  -pie

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/$(NAME) $(LDFLAGS)

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)
