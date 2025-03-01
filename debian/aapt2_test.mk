include /usr/share/dpkg/architecture.mk

NAME = aapt2_test

# tools/aapt2/Android.bp
SOURCES = \
  test/Builders.cpp \
  test/Common.cpp \
  test/Fixture.cpp \

SOURCES := $(foreach source, $(SOURCES), tools/aapt2/$(source))
SOURCES += $(foreach source, $(SOURCES), $(wildcard tools/aapt2/*_test.cpp))
SOURCES += $(foreach source, $(SOURCES), $(wildcard tools/aapt2/*/*_test.cpp))

# If there's no wget, some tests in aapt2_test will be skipped
ifeq (, $(shell which wget))
SOURCES := $(filter-out tools/aapt2/cmd/Compile_test.cpp tools/aapt2/cmd/Convert_test.cpp tools/aapt2/cmd/Link_test.cpp tools/aapt2/process/SymbolTable_test.cpp,$(SOURCES))
endif
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++17 \
  -fno-rtti \

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
  -lgmock \
  -lgtest \
  -lgtest_main \
  -lprotobuf \
  -lutils \
  -lziparchive \
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
