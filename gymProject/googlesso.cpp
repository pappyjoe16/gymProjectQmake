#include "googlesso.h"
#include <QAndroidJniObject>
#include <QCoreApplication>
#include <QDebug>
#include <QDesktopServices>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>
#include <QUrlQuery>
#include <QWebEngineView>
#include <QtAndroid>

GoogleSSO::GoogleSSO(QObject *parent)
    : QObject(parent)
    , networkManager(new QNetworkAccessManager(this))
{
    connect(networkManager,
            &QNetworkAccessManager::finished,
            this,
            &GoogleSSO::onAccessTokenReceived);
}

void GoogleSSO::startGoogleSSO()
{
    QString authUrl
        = QString(
              "https://accounts.google.com/o/oauth2/v2/"
              "auth?response_type=code&client_id=%1&redirect_uri=%2&scope=openid%20email%20profile")
              .arg(clientId, redirectUri);
    qDebug() << "Open this URL in your browser to authenticate:" << authUrl;
    openUrlInBrowser(QUrl(authUrl));
}

void GoogleSSO::onAuthCodeReceived(const QString &code)
{
    authCode = code;
    exchangeAuthCodeForToken();
}

void GoogleSSO::exchangeAuthCodeForToken()
{
    QUrl tokenUrl("https://oauth2.googleapis.com/token");
    QNetworkRequest request(tokenUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QUrlQuery params;
    params.addQueryItem("code", authCode);
    params.addQueryItem("client_id", clientId);
    params.addQueryItem("client_secret", clientSecret);
    params.addQueryItem("redirect_uri", redirectUri);
    params.addQueryItem("grant_type", "authorization_code");

    networkManager->post(request, params.toString(QUrl::FullyEncoded).toUtf8());
}

void GoogleSSO::onAccessTokenReceived()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply)
        return;

    QJsonDocument jsonDoc = QJsonDocument::fromJson(reply->readAll());
    QJsonObject jsonObj = jsonDoc.object();
    accessToken = jsonObj["access_token"].toString();

    fetchUserInfo();
}

void GoogleSSO::fetchUserInfo()
{
    QUrl userInfoUrl("https://www.googleapis.com/oauth2/v2/userinfo");
    QNetworkRequest request(userInfoUrl);
    request.setRawHeader("Authorization", "Bearer " + accessToken.toUtf8());

    connect(networkManager, &QNetworkAccessManager::finished, this, &GoogleSSO::onUserInfoReceived);
    networkManager->get(request);
}

void GoogleSSO::onUserInfoReceived()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply)
        return;

    QJsonDocument jsonDoc = QJsonDocument::fromJson(reply->readAll());
    QJsonObject jsonObj = jsonDoc.object();

    QString email = jsonObj["email"].toString();
    QString name = jsonObj["name"].toString();

    qDebug() << "Email:" << email;
    qDebug() << "Name:" << name;
}

void GoogleSSO::openUrlInBrowser(const QUrl &url)
{
    QAndroidJniObject::callStaticMethod<void>("org/qtproject/example/QtAndroidUtils",
                                              "openUrl",
                                              "(Ljava/lang/String;)V",
                                              QAndroidJniObject::fromString(url.toString())
                                                  .object<jstring>());
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    GoogleSSO sso;
    sso.startGoogleSSO();

    return app.exec();
}
