#ifndef GOOGLESSO_H
#define GOOGLESSO_H

#include <QNetworkAccessManager>
#include <QObject>

class GoogleSSO : public QObject
{
    Q_OBJECT

public:
    explicit GoogleSSO(QObject *parent = nullptr);
    void startGoogleSSO();

private slots:
    void onAuthCodeReceived(const QString &code);
    void onAccessTokenReceived();
    void onUserInfoReceived();

private:
    QNetworkAccessManager *networkManager;
    QString clientId = "YOUR_CLIENT_ID";
    QString clientSecret = "YOUR_CLIENT_SECRET";
    QString redirectUri = "http://localhost:8080";
    QString authCode;
    QString accessToken;

    void exchangeAuthCodeForToken();
    void fetchUserInfo();
    void openUrlInBrowser(const QUrl &url);
};

#endif // GOOGLESSO_H
