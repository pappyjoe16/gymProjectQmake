QT += quick network bluetooth
QT += qml quick widgets core5compat

CONFIG += c++17
TARGET = test2
TEMPLATE = app

SOURCES += \
    #bledevicelistmodel.cpp \
    device.cpp \
    #deviceconnect.cpp \
    deviceinfo.cpp \
    main.cpp \
    pageswitcher.cpp \
    authhandler.cpp \
    #blescanner.cpp \
    base64format.cpp

HEADERS += \
    #bledevicelistmodel.h \
    device.h \
    #deviceconnect.h \
    deviceinfo.h \
    pageswitcher.h \
    authhandler.h \
    #blescanner.h \
    base64format.h \


RESOURCES += qml.qrc

ANDROID {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    LIBS += -L$$PWD/ui/assets/android_openssl-master/ssl_3/arm64-v8a/ -lcrypto_3 -lssl_3
}

ANDROID_EXTRA_LIBS += \
    $$PWD/ui/assets/android_openssl-master/ssl_3/arm64-v8a/libcrypto_3.so \
    $$PWD/ui/assets/android_openssl-master/ssl_3/arm64-v8a/libssl_3.so

macx {
    CONFIG += macx_bundle
    BUNDLE_IDENTIFIER = com.example.test2
    VERSION = 0.1
}

win32 {
    CONFIG += win32
}

OTHER_FILES += \
    android/AndroidManifest.xml

