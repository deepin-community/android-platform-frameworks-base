NAME = libaapt

# tools/aapt/Android.bp
SOURCES = \
  AaptAssets.cpp \
  AaptConfig.cpp \
  AaptUtil.cpp \
  AaptXml.cpp \
  ApkBuilder.cpp \
  Command.cpp \
  CrunchCache.cpp \
  FileFinder.cpp \
  Images.cpp \
  Package.cpp \
  pseudolocalize.cpp \
  Resource.cpp \
  ResourceFilter.cpp \
  ResourceIdCache.cpp \
  ResourceTable.cpp \
  SourcePos.cpp \
  StringPool.cpp \
  WorkQueue.cpp \
  XMLNode.cpp \
  ZipEntry.cpp \
  ZipFile.cpp \

SOURCES := $(foreach source, $(SOURCES), tools/aapt/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CPPFLAGS += \
  -DAAPT_VERSION=\"$(ANDROID_BUILD_TOOLS_VERSION)\" \
  -DSTATIC_ANDROIDFW_FOR_TOOLS \
  -Ilibs/androidfw/include \
  -Wno-error=implicit-fallthrough \
  -Wno-format-y2k \

LDFLAGS += \
  -Ldebian/out \
  -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -landroidfw \
  -lexpat \
  -lpng \
  -lpthread \
  -llog \
  -lutils \
  -lz \
  -shared \

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/$(NAME).so

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)
