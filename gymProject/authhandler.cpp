#include "authhandler.h"
#include <QDebug>
#include <QNetworkRequest>
#include <QVariantMap>
#include "qjsonarray.h"
// #include <QSslKey>
// #include <QSslSocket>
#include <QCoreApplication>
#include <QJsonObject>
#include <QTimer>

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
            qDebug() << "Picture URL main:" << m_url;

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
