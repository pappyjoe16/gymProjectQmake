#ifndef AUTHHANDLER_H
#define AUTHHANDLER_H

#include <QCryptographicHash>
#include <QDesktopServices>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QOAuth2AuthorizationCodeFlow>
#include <QOAuthHttpServerReplyHandler>
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
    Q_INVOKABLE void retriveProfile();
    Q_INVOKABLE void updateUserProfile(const QString &name,
                                       const QString &gender,
                                       const QString &age,
                                       const QString &height,
                                       const QString &weight,
                                       const QString &handHabit,
                                       const QString &profilePicture);
    //Q_INVOKABLE void authenticateWithGoogle();

public slots:
    void networkReplyReadyRead(const QString &errorCheck);
    void firestoreReplyReadyRead();
    void updateFirestoreReplyReadyRead();
    void pictureReplyReadyRead();
    void profileReplyReadyRead();
    //void getAccessToken(std::function<void(QString)> callback);

signals:
    void userSignedIn();
    void resetErrorSignal(QString resetErrorMessage);
    void signInErrorSignal(QString signInErrorMessage);
    void signUpErrorSignal(QString signUpErrorMessage);
    void userAdded();
    void userUpdated();
    void userRetrived(const QString &name,
                      const QString &gender,
                      const QString &age,
                      const QString &height,
                      const QString &weight,
                      const QString &handHabit,
                      const QString &profilePicture);
    //void refreshToken(QString refreshToken);

private:
    void performPOST(const QString &url, const QJsonDocument &payload, const QString &errorCheck);
    void parseResponse(const QByteArray &response, const QString &errorCheck);
    void performPostRequest(const QString &endpoint,
                            const QJsonDocument &payload,
                            const QString &action);
    void performPutRequest(const QString &endpoint,
                           const QJsonDocument &payload,
                           const QString &action);
    QString constructGoogleAuthUrl(const QString &clientId,
                                   const QString &redirectUri,
                                   const QString &scope,
                                   const QString &state);
    // void handleRedirect(const QUrl &url);
    // void exchangeCodeForToken(const QString &code);
    // void handleTokenReply(QNetworkReply *reply);
    // void saveTokens(const QString &accessToken, const QString &refreshToken);
    // QJsonObject loadTokens();
    // void signInWithToken(const QString &accessToken);
    // void handleUserInfoReply(QNetworkReply *reply);

    QString m_apiKey;
    QNetworkAccessManager *m_networkAccessManager;
    QNetworkReply *m_networkReply;
    QString m_idToken;
    QString m_refreshToken;
    QString m_accessToken;
    QString m_uid;
    QString m_docId;
    QString m_emailAddress;
    QString m_url;
    QString m_username;
    QString m_userage;
    QString m_usergender;
    QString m_userheight;
    QString m_userweight;
    QString m_userhandHabit;
    QString m_userprofilePicture;
};

#endif // AUTHHANDLER_H
