#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSslKey>
#include <QSslSocket>
#include "authhandler.h"
#include "base64format.h"
//#include "bledevicelistmodel.h"
//#include "blescanner.h"
#include "device.h"
#include "pageswitcher.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //Q_LOGGING_CATEGORY(defaultLog, "default");

    //Pageswitcher pageControl;
    //AuthHandler authHandler;

    qmlRegisterType<Base64format>("Base64format", 1, 0, "Base64format");
    //qmlRegisterType<BLEDeviceListModel>("BLEDeviceListModel", 1, 0, "BLEDeviceListModel");
    qmlRegisterType<Pageswitcher>("Pageswitcher", 1, 0, "Pageswitcher");
    qmlRegisterType<AuthHandler>("AuthHandler", 1, 0, "AuthHandler");
    qmlRegisterType<Device>("Device", 1, 0, "Device");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);
    //QQmlContext * rootContext = engine.rootContext();
    //rootContext->setContextProperty("myClass", &pageControl);

    return app.exec();
}
