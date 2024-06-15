QT += quick network bluetooth
QT += qml quick widgets core
QT +=  networkauth
QT += httpserver

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG += c++17
TEMPLATE = app

SOURCES += \
    boxingdata.cpp \
    device.cpp \
    deviceinfo.cpp \
    #googlesso.cpp \
    main.cpp \
    pageswitcher.cpp \
    authhandler.cpp \
    base64format.cpp


RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    boxingdata.h \
    device.h \
    deviceinfo.h \
    #googlesso.h \
    pageswitcher.h \
    authhandler.h \
    base64format.h \


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

# contains(ANDROID_TARGET_ARCH,arm64-v8a) {
#     ANDROID_PACKAGE_SOURCE_DIR = \
#         $$PWD/android
# }
