include /usr/share/dpkg/architecture.mk

NAME = aapt

# tools/aapt/Android.bp
SOURCES = Main.cpp
SOURCES := $(foreach source, $(SOURCES), tools/aapt/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CPPFLAGS += \
  -DAAPT_VERSION=\"$(ANDROID_BUILD_TOOLS_VERSION)\" \
  -DSTATIC_ANDROIDFW_FOR_TOOLS \
  -Ilibs/androidfw/include \

LDFLAGS += \
  -Ldebian/out \
  -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -laapt \
  -landroidfw \
  -lutils \
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
