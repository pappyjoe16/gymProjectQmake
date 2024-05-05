#ifndef AUTHHANDLER_H
#define AUTHHANDLER_H

#include <QCryptographicHash>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>

class AuthHandler : public QObject
{
    Q_OBJECT
public:
    explicit AuthHandler(QObject *parent = nullptr);
    ~AuthHandler();
    Q_INVOKABLE void setAPIKey(const QString &apiKey);
    Q_INVOKABLE void signUserUp(const QString &emailAddress, const QString &password);
    Q_INVOKABLE void signUserIn(const QString &emailAddress, const QString &password);
    Q_INVOKABLE void getRestCode(const QString &emailAddress);
    Q_INVOKABLE QString encryptPassword(const QString &password);
    Q_INVOKABLE void addUserProfile(const QString &name,
                                    const QString &gender,
                                    const QString &age,
                                    const QString &height,
                                    const QString &weight,
                                    const QString &handHabit,
                                    const QString &profilePicture);

public slots:
    void networkReplyReadyRead(const QString &errorCheck);
    void firestoreReplyReadyRead();
    void pictureReplyReadyRead();
    //void getAccessToken(std::function<void(QString)> callback);

signals:
    void userSignedIn();
    void resetErrorSignal(QString resetErrorMessage);
    void signInErrorSignal(QString signInErrorMessage);
    void signUpErrorSignal(QString signUpErrorMessage);
    void userAdded();
    //void refreshToken(QString refreshToken);

private:
    void performPOST(const QString &url, const QJsonDocument &payload, const QString &errorCheck);
    void parseResponse(const QByteArray &response, const QString &errorCheck);
    void performPostRequest(const QString &endpoint,
                            const QJsonDocument &payload,
                            const QString &action);

    QString m_apiKey;
    QNetworkAccessManager * m_networkAccessManager;
    QNetworkReply * m_networkReply;
    QString m_idToken;
    QString m_refreshToken;
    QString m_accessToken;
    QString m_uid;
    QString m_emailAddress;
    QString m_url;
};

#endif // AUTHHANDLER_H
