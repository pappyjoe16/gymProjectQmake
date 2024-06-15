#include "authhandler.h"
#include <QCoreApplication>
#include <QDebug>
#include <QDesktopServices>
#include <QEventLoop>
#include <QFile>
#include <QJsonArray>
#include <QJsonObject>
#include <QNetworkRequest>
#include <QTcpServer>
#include <QTcpSocket>
#include <QTimer>
#include <QVariantMap>

AuthHandler::AuthHandler(QObject *parent)
    : QObject{parent}
    , m_apiKey(QString())

{
    m_networkAccessManager = new QNetworkAccessManager (this);
    //qDebug() << " I am created 3333";
}

AuthHandler::~AuthHandler()
{
    m_networkAccessManager->deleteLater();
    //qDebug() << " I am deconstructed 3333";
}

void AuthHandler::setAPIKey(const QString &apiKey)
{
    m_apiKey = apiKey;
}

void AuthHandler::signUserUp(const QString &emailAddress, const QString &password)
{
    QString signUpEndPoint  = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + m_apiKey;

    m_emailAddress = emailAddress;
    QVariantMap variantPayload;
    variantPayload["email"] = emailAddress;
    variantPayload["password"] = password;
    variantPayload["returnSecureToken"] = true;
    
    QJsonDocument jsonPayload = QJsonDocument::fromVariant(variantPayload);
    performPOST(signUpEndPoint, jsonPayload, QString ("signup"));

    //qDebug() << " I am click from signup "<< emailAddress << password;
}

void AuthHandler::signUserIn(const QString &emailAddress, const QString &password)
{
    QString signInEndPoint  = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + m_apiKey;

    m_emailAddress = emailAddress;
    QVariantMap variantPayload;
    variantPayload["email"] = emailAddress;
    variantPayload["password"] = password;
    variantPayload["returnSecureToken"] = true;

    QJsonDocument jsonPayload = QJsonDocument::fromVariant(variantPayload);
    performPOST(signInEndPoint, jsonPayload, QString ("signin"));

    //qDebug() << " I am click from signin "<< emailAddress << password;
}

void AuthHandler::networkReplyReadyRead(const QString &errorCheck)
{
    //qDebug() << m_networkReply->readAll();
    QByteArray response =  m_networkReply->readAll();
    m_networkReply->deleteLater();

    parseResponse(response, errorCheck);
}

void AuthHandler::performPOST(const QString &url, const QJsonDocument &payload, const QString &errorCheck)
{
    QNetworkRequest newRequest((QUrl(url)));
    newRequest.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));
    m_networkReply = m_networkAccessManager->post(newRequest, payload.toJson());
    connect(m_networkReply, &QNetworkReply::readyRead, this, [=]() {
        networkReplyReadyRead(errorCheck);
    });
}

void AuthHandler::parseResponse(const QByteArray &response, const QString &errorCheck)
{
    //qDebug().noquote() << "this is the JSON document of the response:  " << response;
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);
    //qDebug().noquote() << "this is the JSON document of the response:  "
    //                   << jsonDocument.toJson(QJsonDocument::Indented);

    if (jsonDocument.object().contains("error")) {
        QJsonObject errorObject = jsonDocument["error"].toObject();
        QString errorMessage = errorObject["message"].toString();
        qDebug() << "Error occured!" << errorMessage ;

        if(errorCheck =="signup"){
            emit signUpErrorSignal(errorMessage);
        }else if(errorCheck =="signin"){
            if (errorMessage == "TOO_MANY_ATTEMPTS_TRY_LATER : Access to this account has been "
                                "temporarily disabled due to many failed login attempts. You can "
                                "immediately restore it by resetting your password or you can try "
                                "again later.")
            {
                emit signInErrorSignal(QString("TOO_MANY_ATTEMPTS_TRY_LATER"));
            }else{
                emit signInErrorSignal(errorMessage);
            }
        }else if(errorCheck =="resetPassword"){
            emit resetErrorSignal(errorMessage);
        }

    } else if (jsonDocument.object().contains("kind")) {
        QString idToken = jsonDocument.object().value("idToken").toString();
        //qInfo() << "Obtained user ID Token: " << idToken;
        QString refreshToken = jsonDocument.object().value("refreshToken").toString();
        QString uid = jsonDocument.object().value("localId").toString();
        m_idToken = idToken;
        m_refreshToken = refreshToken;
        m_uid = uid;
        //qDebug() << "Obtained user ID Token: " << m_idToken;
        //qDebug() << "Obtained refresh Token: " << m_refreshToken;
        //qDebug() << "Obtained User ID: " << m_uid;
        if(errorCheck =="signup"){
            emit signUpErrorSignal(QString("SUCCESS"));
        } else if (errorCheck == "signin") {
            emit signInErrorSignal(QString("SUCCESS"));
        } else if (errorCheck == "resetPassword") {
            emit resetErrorSignal(QString("SUCCESS"));
        }
    }
}

void AuthHandler::firestoreReplyReadyRead()
{
    m_networkReply = qobject_cast<QNetworkReply *>(sender());

    if (m_networkReply) {
        if (m_networkReply->error() == QNetworkReply::NoError) {
            QByteArray response_data = m_networkReply->readAll();
            //qDebug().noquote() << "Response from user profile:" << response_data;
            emit userAdded();
        } else {
            qDebug() << "Error from user profile:" << m_networkReply->errorString();
        }
        m_networkReply->deleteLater();
        sender()->deleteLater();
    }
}

void AuthHandler::updateFirestoreReplyReadyRead()
{
    m_networkReply = qobject_cast<QNetworkReply *>(sender());

    if (m_networkReply) {
        if (m_networkReply->error() == QNetworkReply::NoError) {
            QByteArray response_data = m_networkReply->readAll();
            //qDebug().noquote() << "Response from user profile:" << response_data;
            emit userUpdated();
        } else {
            qDebug() << "Error from user profile:" << m_networkReply->errorString();
        }
        m_networkReply->deleteLater();
        sender()->deleteLater();
    }
}

void AuthHandler::profileReplyReadyRead()
{
    m_networkReply = qobject_cast<QNetworkReply *>(sender());

    if (m_networkReply) {
        if (m_networkReply->error() == QNetworkReply::NoError) {
            QByteArray response_data = m_networkReply->readAll();
            //qDebug().noquote() << "Response from user profile:" << response_data;
            //QJsonDocument jsonDocument = QJsonDocument::fromJson(response_data);

            QJsonDocument jsonDocument = QJsonDocument::fromJson(response_data);
            QJsonObject jsonObject = jsonDocument.object();

            if (jsonObject["status"].toBool()) {
                QJsonArray dataArray = jsonObject["data"].toArray();

                foreach (const QJsonValue &value, dataArray) {
                    QJsonObject dataObject = value.toObject();

                    QString docId = dataObject["id"].toString();
                    m_docId = docId;

                    QJsonObject innerData = dataObject["data"].toObject();

                    QString username = innerData["name"].toString();
                    QString usergender = innerData["gender"].toString();
                    QString userage = innerData["age"].toString();
                    QString userheight = innerData["height"].toString();
                    QString userweight = innerData["weight"].toString();
                    QString userhandHabit = innerData["handHabit"].toString();
                    QString userprofilePicture = innerData["profileUrl"].toString();

                    m_username = username;
                    m_usergender = usergender;
                    m_userage = userage;
                    m_userheight = userheight;
                    m_userweight = userweight;
                    m_userhandHabit = userhandHabit;
                    m_userprofilePicture = userprofilePicture;
                }
            }
            emit userRetrived(m_username,
                              m_usergender,
                              m_userage,
                              m_userheight,
                              m_userweight,
                              m_userhandHabit,
                              m_userprofilePicture);

        } else {
            qDebug() << "Error from user profile:" << m_networkReply->errorString();
        }
        m_networkReply->deleteLater();
        sender()->deleteLater();
    }
}

void AuthHandler::pictureReplyReadyRead()
{
    m_networkReply = qobject_cast<QNetworkReply *>(sender());
    if (m_networkReply) {
        if (m_networkReply->error() == QNetworkReply::NoError) {
            QByteArray response_data = m_networkReply->readAll();
            //qDebug().noquote() << "Response from Picture:" << response_data;

            QJsonDocument jsonResponse = QJsonDocument::fromJson(response_data);
            QJsonObject jsonObject = jsonResponse.object();

            if (jsonObject.contains("url")) {
                QString url = jsonObject["url"].toString();
                m_url = url;
            }
            //qDebug() << "Picture URL main:" << m_url;

        } else {
            qDebug() << "Error from Picture:" << m_networkReply->errorString();
        }
        m_networkReply->deleteLater();
        sender()->deleteLater();
    }
}

void AuthHandler::performPostRequest(const QString &endpoint,
                                     const QJsonDocument &payload,
                                     const QString &action)
{
    QNetworkRequest newRequest((QUrl(endpoint)));
    newRequest.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));
    m_networkReply = m_networkAccessManager->post(newRequest, payload.toJson());
    if (action == "userProfile") {
        connect(m_networkReply, &QNetworkReply::readyRead, this, [=]() {
            firestoreReplyReadyRead();
        });
    } else if (action == "profilePicture") {
        connect(m_networkReply, &QNetworkReply::readyRead, this, [=]() { pictureReplyReadyRead(); });
    } else if (action == "retriveProfile") {
        connect(m_networkReply, &QNetworkReply::readyRead, this, [=]() { profileReplyReadyRead(); });
    }
}

void AuthHandler::performPutRequest(const QString &endpoint,
                                    const QJsonDocument &payload,
                                    const QString &action)
{
    QNetworkRequest newRequest((QUrl(endpoint)));
    newRequest.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));
    m_networkReply = m_networkAccessManager->put(newRequest, payload.toJson());
    if (action == "updateUserProfile") {
        connect(m_networkReply, &QNetworkReply::readyRead, this, [=]() {
            updateFirestoreReplyReadyRead();
        });
    }
}

void AuthHandler::getRestCode(const QString &emailAddress)
{
    QString resetPasswordEndPoint  = "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=" + m_apiKey;

    QVariantMap variantPayload;
    variantPayload["requestType"] = "PASSWORD_RESET";
    variantPayload["email"] = emailAddress;

    QJsonDocument jsonPayload = QJsonDocument::fromVariant(variantPayload);
    performPOST(resetPasswordEndPoint, jsonPayload, QString ("resetPassword"));

    //qDebug() << " I am click from signin "<< emailAddress ;
}

QString AuthHandler::encryptPassword(const QString &password)
{
    return QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Md5).toHex();
}

void AuthHandler::addUserProfile(const QString &name,
                                 const QString &gender,
                                 const QString &age,
                                 const QString &height,
                                 const QString &weight,
                                 const QString &handHabit,
                                 const QString &profilePicture)
{
    QString addUserProfileEndPoint = "https://adddocument-igqf34gr4q-uc.a.run.app";
    QString addUserPictureEndPoint = "https://uploadfiletostorage-igqf34gr4q-uc.a.run.app";

    QJsonObject profilePictureObject;
    profilePictureObject["base64Data"] = profilePicture;
    profilePictureObject["fileName"] = m_emailAddress + ".jpg";
    profilePictureObject["uid"] = m_uid;

    QJsonDocument picturePayloadDocument(profilePictureObject);

    performPostRequest(addUserPictureEndPoint, picturePayloadDocument, QString("profilePicture"));
    while (m_url == "") {
        pictureReplyReadyRead();
        QEventLoop loop;
        QTimer::singleShot(500, &loop, SLOT(quit())); // 1000 milliseconds = 1 second
        loop.exec();
    }

    QJsonObject profileObject;
    profileObject["name"] = name;
    profileObject["email"] = m_emailAddress;
    profileObject["gender"] = gender;
    profileObject["age"] = age;
    profileObject["height"] = height;
    profileObject["weight"] = weight;
    profileObject["handHabit"] = handHabit;
    profileObject["uid"] = m_uid;
    profileObject["profileUrl"] = m_url;

    QJsonObject profilePayloadObject;
    profilePayloadObject["collection"] = "userProfiles";
    profilePayloadObject["data"] = profileObject;

    QJsonDocument profilePayloadDocument(profilePayloadObject);

    performPostRequest(addUserProfileEndPoint, profilePayloadDocument, QString("userProfile"));
}

void AuthHandler::retriveProfile()
{
    QString UserProfileEndPoint = "https://getquerieddocs-igqf34gr4q-uc.a.run.app";

    QJsonObject payload;
    payload["collection"] = "userProfiles";

    QJsonArray whereArray;
    QJsonObject whereObject;
    whereObject["fieldPath"] = "uid";
    whereObject["opStr"] = "==";
    whereObject["value"] = m_uid;
    whereArray.append(whereObject);

    payload["where"] = whereArray;
    payload["limit"] = 1;

    QJsonDocument retrivePayloadDoc(payload);

    performPostRequest(UserProfileEndPoint, retrivePayloadDoc, QString("retriveProfile"));
}

void AuthHandler::updateUserProfile(const QString &name,
                                    const QString &gender,
                                    const QString &age,
                                    const QString &height,
                                    const QString &weight,
                                    const QString &handHabit,
                                    const QString &profilePicture)
{
    QString updateUserProfileEndPoint = "https://updatedocument-igqf34gr4q-uc.a.run.app";
    QString updateUserPictureEndPoint = "https://uploadfiletostorage-igqf34gr4q-uc.a.run.app";

    if (!profilePicture.isEmpty()) {
        QJsonObject profilePictureObject;
        profilePictureObject["base64Data"] = profilePicture;
        profilePictureObject["fileName"] = m_emailAddress + ".jpg";
        profilePictureObject["uid"] = m_uid;

        QJsonDocument picturePayloadDocument(profilePictureObject);

        performPostRequest(updateUserPictureEndPoint,
                           picturePayloadDocument,
                           QString("profilePicture"));
        while (m_url.isEmpty()) {
            pictureReplyReadyRead();
            QEventLoop loop;
            QTimer::singleShot(200, &loop, SLOT(quit())); // 1000 milliseconds = 1 second
            loop.exec();
        }
    }

    QJsonObject profileObject;
    profileObject["name"] = name;
    profileObject["gender"] = gender;
    profileObject["age"] = age;
    profileObject["height"] = height;
    profileObject["weight"] = weight;
    profileObject["handHabit"] = handHabit;
    if (!profilePicture.isEmpty()) {
        profileObject["profileUrl"] = m_url;
    }

    QJsonObject profilePayloadObject;
    profilePayloadObject["collection"] = "userProfiles";
    profilePayloadObject["id"] = m_docId;
    profilePayloadObject["data"] = profileObject;

    QJsonDocument profilePayloadDocument(profilePayloadObject);

    performPutRequest(updateUserProfileEndPoint,
                      profilePayloadDocument,
                      QString("updateUserProfile"));
}

// void AuthHandler::authenticateWithGoogle()
// {
//     // Construct the authorization URL with the correct redirect URI
//     QString redirectUri = "http://localhost:3000";
//     QString authUrl = constructGoogleAuthUrl(
//         "981640700306-0r5qsvipvg358kgcsmbf72jngh9no21b.apps.googleusercontent.com",
//         redirectUri,
//         "profile email",
//         "random_state_string");

//     // Start the OAuth flow by opening the authorization URL in the default web browser
//     QDesktopServices::openUrl(QUrl(authUrl));
// }

// QString AuthHandler::constructGoogleAuthUrl(const QString &clientId,
//                                             const QString &redirectUri,
//                                             const QString &scope,
//                                             const QString &state)
// {
//     QUrl authUrl("https://accounts.google.com/o/oauth2/v2/auth");

//     QUrlQuery query;
//     query.addQueryItem("client_id", clientId);
//     query.addQueryItem("redirect_uri", redirectUri);
//     query.addQueryItem("response_type", "code");
//     query.addQueryItem("scope", scope);
//     if (!state.isEmpty()) {
//         query.addQueryItem("state", state);
//     }
//     query.addQueryItem("access_type", "offline");
//     query.addQueryItem("prompt", "consent");

//     authUrl.setQuery(query);
//     return authUrl.toString();
// }
// void AuthHandler::handleRedirect(const QUrl &url)
// {
//     QUrlQuery query(url.query());
//     QString code = query.queryItemValue("code");

//     if (!code.isEmpty()) {
//         exchangeCodeForToken(code);
//     }
// }
// void AuthHandler::exchangeCodeForToken(const QString &code)
// {
//     QUrl tokenUrl("https://oauth2.googleapis.com/token");
//     QNetworkRequest request(tokenUrl);
//     request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

//     QUrlQuery params;
//     params.addQueryItem("code", code);
//     params.addQueryItem("client_id",
//                         "981640700306-0r5qsvipvg358kgcsmbf72jngh9no21b.apps.googleusercontent.com");
//     params.addQueryItem("client_secret", "YOUR_CLIENT_SECRET");
//     params.addQueryItem("redirect_uri", "http://localhost:3000");
//     params.addQueryItem("grant_type", "authorization_code");

//     auto networkManager = new QNetworkAccessManager(this);
//     connect(networkManager, &QNetworkAccessManager::finished, this, &AuthHandler::handleTokenReply);
//     networkManager->post(request, params.toString(QUrl::FullyEncoded).toUtf8());
// }

// void AuthHandler::handleTokenReply(QNetworkReply *reply)
// {
//     if (reply->error() == QNetworkReply::NoError) {
//         QByteArray response = reply->readAll();
//         QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
//         QJsonObject jsonObj = jsonDoc.object();
//         m_accessToken = jsonObj["access_token"].toString();
//         QString refreshToken = jsonObj["refresh_token"].toString();

//         // Save tokens for future use
//         saveTokens(m_accessToken, refreshToken);

//         // Automatically sign in next time
//         signInWithToken(m_accessToken);
//     } else {
//         qDebug() << "Error in token exchange: " << reply->errorString();
//     }
//     reply->deleteLater();
// }
// void AuthHandler::saveTokens(const QString &accessToken, const QString &refreshToken)
// {
//     QFile file("tokens.json");
//     if (file.open(QIODevice::WriteOnly)) {
//         QJsonObject jsonObj;
//         jsonObj["access_token"] = accessToken;
//         jsonObj["refresh_token"] = refreshToken;
//         file.write(QJsonDocument(jsonObj).toJson());
//         file.close();
//     }
// }

// QJsonObject AuthHandler::loadTokens()
// {
//     QFile file("tokens.json");
//     if (file.open(QIODevice::ReadOnly)) {
//         QJsonDocument jsonDoc = QJsonDocument::fromJson(file.readAll());
//         file.close();
//         return jsonDoc.object();
//     }
//     return QJsonObject();
// }
// void AuthHandler::signInWithToken(const QString &accessToken)
// {
//     QNetworkRequest request(QUrl("https://www.googleapis.com/oauth2/v1/userinfo?alt=json"));
//     request.setRawHeader("Authorization", ("Bearer " + accessToken).toUtf8());

//     auto networkManager = new QNetworkAccessManager(this);
//     connect(networkManager,
//             &QNetworkAccessManager::finished,
//             this,
//             &AuthHandler::handleUserInfoReply);
//     networkManager->get(request);
// }

// void AuthHandler::handleUserInfoReply(QNetworkReply *reply)
// {
//     if (reply->error() == QNetworkReply::NoError) {
//         QByteArray response = reply->readAll();
//         QJsonDocument jsonDoc = QJsonDocument::fromJson(response);
//         QJsonObject jsonObj = jsonDoc.object();
//         QString userName = jsonObj["name"].toString();
//         QString userEmail = jsonObj["email"].toString();

//         qDebug() << "User Name: " << userName;
//         qDebug() << "User Email: " << userEmail;
//     } else {
//         qDebug() << "Error in fetching user info: " << reply->errorString();
//     }
//     reply->deleteLater();
// }
