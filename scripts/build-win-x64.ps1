$SCRIPTS_DIR="$PSScriptRoot"
$BASE_DIR="$SCRIPTS_DIR/.."
$SOURCES_DIR="$BASE_DIR/sources"
$ARTIFACTS_DIR="$BASE_DIR/artifacts"

$TARGET_DIR="$ARTIFACTS_DIR/win-x64"

pushd "$SOURCES_DIR/tesseract"
rm -Recurse -Force build
mkdir build
pushd "build"
. cmake .. -DDISABLED_LEGACY_ENGINE=ON -DBUILD_TRAINING_TOOLS=OFF  -DCMAKE_SYSTEM_VERSION=7 -DBUILD_SHARED_LIBS=OFF -DGRAPHICS_DISABLED=ON -DENABLE_LTO=ON
. cmake --build . --config Release
popd
popd

# TODO: Maybe build our own leptonica

cp "$SOURCES_DIR/tesseract/build/bin/Release/tesseract.exe" "$TARGET_DIR/tesseract.exe"
cp "$SOURCES_DIR/tesseract/AUTHORS" "$TARGET_DIR/../tesseract-authors.txt"