NAME = libaapt
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
CPPFLAGS += -Ilibs/androidfw/include \
            -I/usr/include/android \
            -Wno-format-y2k -Wno-error=implicit-fallthrough \
	    -DSTATIC_ANDROIDFW_FOR_TOOLS \
            -DAAPT_VERSION=\"$(ANDROID_BUILD_TOOLS_VERSION)\"
CXXFLAGS += -std=gnu++17
LDFLAGS += -shared -Wl,-soname,$(NAME).so.0 \
           -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -lpng -lexpat -lz -lpthread \
           -Ldebian/out -landroidfw \
           -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -llog -lutils -llog

build: $(SOURCES)
	mkdir --parents debian/out
	$(CXX) $^ -o debian/out/$(NAME).so.0 $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)
	ln -s $(NAME).so.0 debian/out/$(NAME).so