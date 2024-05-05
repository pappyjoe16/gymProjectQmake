#include "base64format.h"
#include <QBuffer>
#include <QByteArray>
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QImage>
#include <QUrl>
#include <QtQml>

Base64format::Base64format(QObject *parent)
    : QObject(parent)
{}

Base64format::~Base64format()
{
    qInfo() << "Base64format is deconstructed";
}

void Base64format::handleUserProfileImage(const QString &imageUrl)
{
    //qDebug() << "I handleUserProfileImage is called";
    QUrl url(imageUrl);

    //qDebug() << "File localUrl: " << imageUrl;

    QImage image;
    QString filePath;

    if (url.isLocalFile()) {
        filePath = url.toLocalFile();
    } else if (isContentUri(imageUrl)) {
        //qDebug() << "the url is content url";
        QString path(imageUrl);
        QUrl pathUrl(path);
        filePath = QQmlFile::urlToLocalFileOrQrc(pathUrl);
    } else {
        qInfo() << "Not a local file URL.";
        return;
    }

    //qDebug() << "File Path:" << filePath;

    if (!image.load(filePath)) {
        qInfo() << "Failed to load the image.";
        return;
    }

    QBuffer buffer;
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "PNG"); // You can replace "PNG" with the desired format

    QString base64String = buffer.data().toBase64();

    // Process the Base64 string or perform other actions
    //qDebug() << "Base64 User Profile Image: " << base64String;
    //qDebug() << "I returned the value i got.....";
    emit sendBase64String(base64String);
    //return base64String;
}

bool Base64format::isContentUri(const QString &uri)
{
    // Check if the URI starts with the "content://" scheme
    return uri.startsWith("content://");
}
