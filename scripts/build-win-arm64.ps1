# TODO: Actual build script?
# The custom sw-build doesn't work with Windows arm64. So we use vcpkg instead.
# This results in a bigger binary than we want, but it's not a big deal (the NAPS2 arm64 installer is smaller to begin
# with anyway since we don't need a worker).

# git clone https://github.com/microsoft/vcpkg
# vcpkg\bootstrap-vcpkg.bat
# vcpkg\vcpkg install tesseract:arm64-windows-static