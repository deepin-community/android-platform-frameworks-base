% SPLIT-SELECT(1)
% The Android Open Source Project

# NAME

split-select - APK split and selection tool

WARNING: This manual might be outdated, please refer to `split-select --help`.

# SYNOPSIS

**split-select** --help

**split-select** --target _config_ --base _path/to/apk_
                 [--split _path/to/apk_ [...]]

**split-select** --generate --base _path/to/apk_ [--split _path/to/apk_ [...]]

# OPTIONS

--help
: Displays more information about this program.

--target _config_
: Performs the Split APK selection on the given configuration.

--generate
: Generates the logic for selecting the Split APK, in JSON format.

--base _path/to/apk_
: Specifies the base APK, from which all Split APKs must be based off.

--split _path/to/apk_
: Includes a Split APK in the selection process.

Where **config** is an extended AAPT resource qualifier of the form
"resource-qualifiers:extended-qualifiers", where "resource-qualifiers" is an
AAPT resource qualifier (ex: en-rUS-sw600dp-xhdpi), and 'extended-qualifiers'
is an ordered list of one qualifier (or none) from each category:

```
Architecture: armeabi, armeabi-v7a, arm64-v8a, x86, x86_64, mips
```

Generates the logic for selecting a Split APK given some target Android device
configuration. Using the flag **--generate** will emit a JSON encoded tree of
rules that must be satisfied in order to install the given Split APK. Using the
flag **--target** along with the device configuration will emit the set of Split
APKs to install, following the same logic that would have been emitted via JSON.