include /usr/share/dpkg/architecture.mk

NAME = aapt2

# tools/aapt2/Android.bp
SOURCES = Main.cpp
SOURCES := $(foreach source, $(SOURCES), tools/aapt2/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -fno-rtti
CPPFLAGS += \
  -Idebian/out/proto/frameworks/base/tools/aapt2 \
  -Ilibs/androidfw/include \
  -Itools/aapt2 \
  -Wno-unused-parameter \
  -Wno-missing-field-initializers \

LDFLAGS += \
  -Ldebian/out \
  -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -laapt2 \
  -landroidfw \
  -lbase \
  -pie

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/$(NAME) $(LDFLAGS)

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)
