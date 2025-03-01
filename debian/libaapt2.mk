NAME = libaapt2

# tools/aapt2/Android.bp
SOURCES = \
  cmd/Command.cpp \
  cmd/Compile.cpp \
  cmd/Convert.cpp \
  cmd/Diff.cpp \
  cmd/Dump.cpp \
  cmd/Link.cpp \
  cmd/Optimize.cpp \
  cmd/Util.cpp \
  \
  compile/IdAssigner.cpp \
  compile/InlineXmlFormatParser.cpp \
  compile/NinePatch.cpp \
  compile/Png.cpp \
  compile/PngChunkFilter.cpp \
  compile/PngCrunch.cpp \
  compile/PseudolocaleGenerator.cpp \
  compile/Pseudolocalizer.cpp \
  compile/XmlIdCollector.cpp \
  configuration/ConfigurationParser.cpp \
  dump/DumpManifest.cpp \
  filter/AbiFilter.cpp \
  filter/ConfigFilter.cpp \
  format/Archive.cpp \
  format/Container.cpp \
  format/binary/BinaryResourceParser.cpp \
  format/binary/ResChunkPullParser.cpp \
  format/binary/TableFlattener.cpp \
  format/binary/XmlFlattener.cpp \
  format/proto/ProtoDeserialize.cpp \
  format/proto/ProtoSerialize.cpp \
  io/BigBufferStream.cpp \
  io/File.cpp \
  io/FileStream.cpp \
  io/FileSystem.cpp \
  io/StringStream.cpp \
  io/Util.cpp \
  io/ZipArchive.cpp \
  link/AutoVersioner.cpp \
  link/ManifestFixer.cpp \
  link/NoDefaultResourceRemover.cpp \
  link/ProductFilter.cpp \
  link/PrivateAttributeMover.cpp \
  link/ReferenceLinker.cpp \
  link/ResourceExcluder.cpp \
  link/TableMerger.cpp \
  link/XmlCompatVersioner.cpp \
  link/XmlNamespaceRemover.cpp \
  link/XmlReferenceLinker.cpp \
  optimize/MultiApkGenerator.cpp \
  optimize/ResourceDeduper.cpp \
  optimize/ResourceFilter.cpp \
  optimize/ResourcePathShortener.cpp \
  optimize/VersionCollapser.cpp \
  process/SymbolTable.cpp \
  split/TableSplitter.cpp \
  text/Printer.cpp \
  text/Unicode.cpp \
  text/Utf8Iterator.cpp \
  util/BigBuffer.cpp \
  util/Files.cpp \
  util/Util.cpp \
  Debug.cpp \
  DominatorTree.cpp \
  java/AnnotationProcessor.cpp \
  java/ClassDefinition.cpp \
  java/JavaClassGenerator.cpp \
  java/ManifestClassGenerator.cpp \
  java/ProguardRules.cpp \
  LoadedApk.cpp \
  Resource.cpp \
  ResourceParser.cpp \
  ResourceTable.cpp \
  ResourceUtils.cpp \
  ResourceValues.cpp \
  SdkConstants.cpp \
  StringPool.cpp \
  trace/TraceBuffer.cpp \
  xml/XmlActionExecutor.cpp \
  xml/XmlDom.cpp \
  xml/XmlPullParser.cpp \
  xml/XmlUtil.cpp \
  Configuration.proto \
  Resources.proto \
  ResourcesInternal.proto \
  ValueTransformer.cpp \

SOURCES := $(foreach source, $(SOURCES), tools/aapt2/$(source))
SOURCES += \
	debian/out/proto/frameworks/base/tools/aapt2/Configuration.pb.cc \
	debian/out/proto/frameworks/base/tools/aapt2/Resources.pb.cc \
	debian/out/proto/frameworks/base/tools/aapt2/ResourcesInternal.pb.cc
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.o)
SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)

CXXFLAGS += -std=gnu++17 \
  -fno-rtti \

CPPFLAGS += \
  -Icmds/idmap2/libidmap2_policies/include \
  -Idebian/out/proto/frameworks/base/tools/aapt2 \
  -Ilibs/androidfw/include \
  -Itools/aapt2 \
  -Wno-unused-parameter \
  -Wno-missing-field-initializers \

LDFLAGS += \
  -Ldebian/out \
  -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -landroidfw \
  -lbase \
  -lexpat \
  -lpng \
  -lprotobuf \
  -shared \

build: $(OBJECTS_CC) $(OBJECTS_CPP)
	$(CXX) $^ -o debian/out/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/$(NAME).so

$(OBJECTS_CPP): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

debian/out/proto/frameworks/base/tools/aapt2/%.pb.cc: tools/aapt2/%.proto
	mkdir -p debian/out/proto/frameworks/base/tools/aapt2
	protoc --cpp_out=debian/out/proto/frameworks/base/tools/aapt2 \
		--proto_path=tools/aapt2 $<
