NAME = libandroidfw

# libs/androidfw/Android.bp
SOURCES = \
  ApkAssets.cpp \
  Asset.cpp \
  AssetDir.cpp \
  AssetManager.cpp \
  AssetManager2.cpp \
  AssetsProvider.cpp \
  AttributeResolution.cpp \
  ChunkIterator.cpp \
  ConfigDescription.cpp \
  Idmap.cpp \
  LoadedArsc.cpp \
  Locale.cpp \
  LocaleData.cpp \
  misc.cpp \
  ObbFile.cpp \
  PosixUtils.cpp \
  ResourceTypes.cpp \
  ResourceUtils.cpp \
  StreamingZipInflater.cpp \
  TypeWrappers.cpp \
  Util.cpp \
  ZipFileRO.cpp \
  ZipUtils.cpp \
  \
#  CursorWindow.cpp \

SOURCES := $(foreach source, $(SOURCES), libs/androidfw/$(source))
OBJECTS = $(SOURCES:.cpp=.o)
CXXFLAGS += -std=gnu++17 \
  -Wno-missing-field-initializers \
  -Wunreachable-code \

CPPFLAGS += \
  -DSTATIC_ANDROIDFW_FOR_TOOLS \
  -Ilibs/androidfw/include \

LDFLAGS += \
  -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -lbase \
  -llog \
  -lutils \
  -lz \
  -lziparchive \
  -shared \

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/$(NAME).so

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)
