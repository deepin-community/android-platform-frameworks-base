NAME = libandroidfw
SOURCES = \
        ApkAssets.cpp \
        Asset.cpp \
        AssetDir.cpp \
        AssetManager.cpp \
        AssetManager2.cpp \
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

SOURCES := $(foreach source, $(SOURCES), libs/androidfw/$(source))
CXXFLAGS += -DSTATIC_ANDROIDFW_FOR_TOOLS -std=gnu++17
CPPFLAGS += -Ilibs/androidfw/include \
            -I/usr/include/android \

LDFLAGS += -shared -Wl,-soname,$(NAME).so.0 \
           -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -lz \
           -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -lziparchive -lutils -llog -lbase

build: $(SOURCES)
	mkdir --parents debian/out
	$(CXX) $^ -o debian/out/$(NAME).so.0 $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)
	ln -s $(NAME).so.0 debian/out/$(NAME).so