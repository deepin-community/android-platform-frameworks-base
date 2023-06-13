
include /usr/share/dpkg/architecture.mk

NAME = aapt
SOURCES = Main.cpp
SOURCES := $(foreach source, $(SOURCES), tools/aapt/$(source))
CPPFLAGS += -DSTATIC_ANDROIDFW_FOR_TOOLS \
            -DAAPT_VERSION=\"$(ANDROID_BUILD_TOOLS_VERSION)\" \
            -Ilibs/androidfw/include \
            -I/usr/include/android \

CXXFLAGS += -std=gnu++17
LDFLAGS += -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -Wl,-rpath-link=debian/out -Ldebian/out -laapt \
           -L/usr/lib/$(DEB_HOST_MULTIARCH)/android -lutils

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifeq ($(DEB_HOST_ARCH), armel)
  LDFLAGS += -latomic
endif
ifeq ($(DEB_HOST_ARCH), mipsel)
  LDFLAGS += -latomic
endif

build: $(SOURCES)
	mkdir --parents debian/out
	$(CXX) $^ -o debian/out/$(NAME) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)