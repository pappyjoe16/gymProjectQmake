#include "device.h"
#include <QBluetoothAddress>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QBluetoothLocalDevice>
#include <QBluetoothServiceDiscoveryAgent>
#include <QDebug>
#include <QJniObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QList>
#include <QMessageBox>
#include <QString>
#include <QStringList>
#include <jni.h>
#include <qbluetoothuuid.h>

#if QT_CONFIG(permissions)
#include <QtCore/qcoreapplication.h>
#include <QtCore/qpermissions.h>
#endif

Device *Device::instance = nullptr;

Device::Device(QObject *parent)
    : QObject{parent}
{
    instance = this;
    qWarning() << "Device class called.";
    //javaCall();
    discoveryAgent = new QBluetoothDeviceDiscoveryAgent();
    connect(discoveryAgent,
            SIGNAL(deviceDiscovered(const QBluetoothDeviceInfo &)),
            this,
            SLOT(addDevice(const QBluetoothDeviceInfo &)));
}

QVariant Device::name()
{
    return QVariant::fromValue(devices);
}

Device::~Device()
{
    qDeleteAll(devices);
    devices.clear();
}

void Device::startDeviceDiscovery()
{
#if QT_CONFIG(permissions)
    //! [permissions]
    QBluetoothPermission permission{};
    permission.setCommunicationModes(QBluetoothPermission::Access);
    switch (qApp->checkPermission(permission)) {
    case Qt::PermissionStatus::Undetermined:
        qApp->requestPermission(permission, this, &Device::startDeviceDiscovery);
        return;
    case Qt::PermissionStatus::Denied:
        qDebug() << "Error Bluetooth permissions not granted!";
        return;
    case Qt::PermissionStatus::Granted:
        break; // proceed to search
    }
    //! [permissions]
#endif // QT_CONFIG(permissions)
    qDeleteAll(devices);
    devices.clear();
    discoveryAgent->start();
    //qWarning() << "Starting to Scan.";
}

void Device::connectDevice(const QString &address)
{
    for (int i = 0; i < devices.size(); i++) {
        if (((DeviceInfo *) devices.at(i))->getAddress() == address) {
            m_currentDevice.setDevice(((DeviceInfo *) devices.at(i))->getDevice());
            //qWarning() << "Connecting to Device";
            break;
        }
    }

    m_control = QLowEnergyController::createCentral(m_currentDevice.getDevice(), this);
    connect(m_control,
            SIGNAL(serviceDiscovered(QBluetoothUuid)),
            this,
            SLOT(serviceDiscovered(QBluetoothUuid)));
    connect(m_control, SIGNAL(discoveryFinished()), this, SLOT(serviceScanDone()));
    connect(m_control,
            SIGNAL(errorOccurred(QLowEnergyController::Error)),
            this,
            SLOT(controllerError(QLowEnergyController::Error)));
    connect(m_control, SIGNAL(connected()), this, SLOT(deviceConnected()));
    connect(m_control, SIGNAL(disconnected()), this, SLOT(deviceDisconnected()));

    m_control->connectToDevice();
}

void Device::addDevice(const QBluetoothDeviceInfo &info)
{
    if (info.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        DeviceInfo *d = new DeviceInfo(info);
        if (d->getName().contains("HW")) {
            devices.append(d);
            qWarning() << "Discovered BLE Device " + d->getName() << "Address: " + d->getAddress();
            emit sendAddressHeart(QString(d->getName()), QString(d->getAddress()));
        }

        if (d->getName().contains("BX100-L")) {
            devices.append(d);
            m_leftMacAddress = QString(d->getAddress());
            qWarning() << "Discovered BLE Device " + d->getName() << "Address: " + d->getAddress();
            emit sendAddressLeft(QString(d->getName().remove("BX100-L")), QString(d->getAddress()));
        }

        if (d->getName().contains("BX100-R")) {
            devices.append(d);
            m_rightMacAddress = QString(d->getAddress());
            qWarning() << "Discovered BLE Device " + d->getName() << "Address: " + d->getAddress();
            emit sendAddressRight(QString(d->getName().remove("BX100-R")), QString(d->getAddress()));
        }
    }
}

void Device::serviceDiscovered(const QBluetoothUuid &gatt)
{
    if (gatt == QBluetoothUuid(QBluetoothUuid::ServiceClassUuid::HeartRate)) {
        qWarning() << "Found Heart Rate Sensor";
        m_foundHeartRateService = true;
    }
}

void Device::serviceScanDone()
{
    qWarning() << "Service Scan Done. waiting to connect to service.";
    qInfo() << ("Service scan done.");

    // Delete old service if available
    if (m_service) {
        delete m_service;
        m_service = nullptr;
    }

    //! [Filter HeartRate service 2]
    // If heartRateService found, create new service
    if (m_foundHeartRateService)
        m_service = m_control->createServiceObject(QBluetoothUuid(
                                                       QBluetoothUuid::ServiceClassUuid::HeartRate),
                                                   this);

    if (m_service) {
        connect(m_service, &QLowEnergyService::stateChanged, this, &Device::serviceStateChanged);
        connect(m_service,
                &QLowEnergyService::characteristicChanged,
                this,
                &Device::updateHeartRateValue);
        connect(m_service,
                &QLowEnergyService::descriptorWritten,
                this,
                &Device::confirmedDescriptorWrite);
        m_service->discoverDetails();
    } else {
        qWarning() << "Heart Rate Service not found.";
    }
    //! [Filter HeartRate service 2]
}

//! [Find HRM characteristic]
void Device::serviceStateChanged(QLowEnergyService::ServiceState s)
{
    switch (s) {
    case QLowEnergyService::RemoteServiceDiscovering:
        qInfo() << (tr("Discovering services..."));
        break;
    case QLowEnergyService::RemoteServiceDiscovered: {
        qInfo() << (tr("Service discovered."));

        const QLowEnergyCharacteristic hrChar = m_service->characteristic(
            QBluetoothUuid(QBluetoothUuid::CharacteristicType::HeartRateMeasurement));
        if (!hrChar.isValid()) {
            qWarning() << ("HR Data not found.");
            break;
        }

        m_notificationDesc = hrChar.descriptor(
            QBluetoothUuid::DescriptorType::ClientCharacteristicConfiguration);
        if (m_notificationDesc.isValid())
            m_service->writeDescriptor(m_notificationDesc, QByteArray::fromHex("0100"));

        break;
    }
    default:
        //nothing for now
        break;
    }
}
//! [Find HRM characteristic]
//!

void Device::updateHeartRateValue(const QLowEnergyCharacteristic &c, const QByteArray &value)
{
    // ignore any other characteristic change -> shouldn't really happen though
    if (c.uuid() != QBluetoothUuid(QBluetoothUuid::CharacteristicType::HeartRateMeasurement))
        return;

    auto data = reinterpret_cast<const quint8 *>(value.constData());
    quint8 flags = *data;

    //Heart Rate
    int hrvalue = 0;
    if (flags & 0x1) // HR 16 bit? otherwise 8 bit
        hrvalue = static_cast<int>(qFromLittleEndian<quint16>(data[1]));
    else
        hrvalue = static_cast<int>(data[1]);

    //qWarning() << "HR Value:" + QString::number(hrvalue);
    emit measuringChanged(QString::number(hrvalue));
}
//! [Reading value]

void Device::confirmedDescriptorWrite(const QLowEnergyDescriptor &d, const QByteArray &value)
{
    if (d.isValid() && d == m_notificationDesc && value == QByteArray::fromHex("0000")) {
        //disabled notifications -> assume disconnect intent
        m_control->disconnectFromDevice();
        delete m_service;
        m_service = nullptr;
    }
}

void Device::controllerError(QLowEnergyController::Error error)
{
    qWarning() << "Controller Error: " << error << "Cannot connect to remote device.";
}

void Device::deviceConnected()
{
    m_control->discoverServices();
}

void Device::deviceDisconnected()
{
    //m_control->disconnectFromDevice();
    qWarning() << "Remote DeviceDisconnected";
}

void Device::bleDeviceDisconnected()
{
    m_control->disconnectFromDevice();
    qWarning() << "Remote DeviceDisconnected";
}

// void Device::javaCall()
// {
//     QString javaMessage = QJniObject::callStaticMethod<jstring>("org/qtproject/example/JavaClass",
//                                                                 "getJavaMessage")
//                               .toString();
//     qWarning() << "Output from qt C++: " << javaMessage;
// }

void Device::javaDisconnectDevice()
{
    QJniObject::callStaticMethod<void>("org/qtproject/example/JavaClass", "disconnectDevice");
}

void Device::javaConnectDevice(const QString &address)
{
    //qWarning() << "javaConnectDevice is called with: " << address;
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    QJniObject jMacAddress = QJniObject::fromString(address);
    QJniObject::callStaticMethod<void>("org/qtproject/example/JavaClass",
                                       "connectToDevice",
                                       "(Ljava/lang/String;Landroid/app/Activity;)V",
                                       jMacAddress.object<jstring>(),
                                       activity.object<jobject>());

    //qWarning() << "End of javaConnectDevice call with: " << address;

    //emit the signal to get userWeight from profilepage
    emit callForWeight();
}

QString Device::returnUserWeight() const
{
    //qWarning() << "User weight received22222: " << m_userWeight;
    return m_userWeight;
}

Device *Device::getInstance()
{
    return instance;
}

QString Device::getLeftMacAddress() const
{
    return m_leftMacAddress;
}

QString Device::getRightMacAddress() const
{
    return m_rightMacAddress;
}
void Device::getWeight(const QString &userWeight)
{
    QStringList weight = userWeight.split(" ");
    m_userWeight = weight[0];
    //qDebug() << "User weight received1111: " << m_userWeight;
    //qDebug() << "User weight index 0: " << weight[0];
}

extern "C" JNIEXPORT void JNICALL Java_org_qtproject_example_JavaClass_onRealTimeBoxingData(
    JNIEnv *env, jclass clazz, jstring macAdd, jstring jsonData)
{
    Q_UNUSED(clazz);
    const char *nativeMacAdd = env->GetStringUTFChars(macAdd, 0);
    const char *nativeJsonData = env->GetStringUTFChars(jsonData, 0);
    static int rightPunchCount = 0;
    static int leftPunchCount = 0;
    static int leftHookCounter = 0;
    static int leftUppercutCounter = 0;
    static int leftStraightCounter = 0;
    static int rightHookCounter = 0;
    static int rightUppercutCounter = 0;
    static int rightStraightCounter = 0;

    // Convert the JSON string to a QJsonObject
    QString jmacAdd = QString::fromUtf8(nativeMacAdd);
    QString jsonString = QString::fromUtf8(nativeJsonData);
    QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonString.toUtf8());
    QJsonObject jsonObject = jsonDoc.object();
    int userWeight = 0.0;

    Device *instance = Device::getInstance();

    if (instance) {
        QString leftMacAddress = instance->getLeftMacAddress();
        QString rightMacAddress = instance->getRightMacAddress();

        userWeight = instance->returnUserWeight().toDouble();
        //qDebug() << "User weight: " << userWeight;

        if (jmacAdd == leftMacAddress) {
            leftPunchCount++;
            //qWarning() << "Real-time boxing data received from left sensor. Punch number:"
            //           << QString::number(leftPunchCount);
            QString punchType;
            if (jsonObject["fistType"].toString() == "1") {
                punchType = "Hook";
                leftHookCounter++;
            } else if (jsonObject["fistType"].toString() == "2") {
                punchType = "Uppercut";
                leftUppercutCounter++;
            } else if (jsonObject["fistType"].toString() == "3") {
                punchType = "Straight punch";
                leftStraightCounter++;
            } else {
                punchType = "Unknown";
            }
            QString punchPower = jsonObject["fistPower"].toString();
            QString punchSpeed = jsonObject["fistSpeed"].toString();
            double punchTime = jsonObject["fistOutTime"].toString().toDouble();
            QString punchDate = jsonObject["fistDate"].toString();
            QString punchDistance = jsonObject["fistDistance"].toString();

            qDebug() << "Left Punch Speed: " << punchSpeed;
            qDebug() << "Left Punch Power: " << punchPower;
            qDebug() << "Left Punch Time: " << QString::number(punchTime);
            qDebug() << "Left Punch Date: " << punchDate;
            qDebug() << "Left Punch Type: " << punchType;
            qDebug() << "Left Punch Distance: " << punchDistance;
            qDebug() << "Left Punch Count: " << QString::number(leftPunchCount);
            qDebug() << "Left Hook punch Count: " << QString::number(leftHookCounter);
            qDebug() << "Left Uppercut punch Count: " << QString::number(leftUppercutCounter);
            qDebug() << "Left Straight punch Count: " << QString::number(leftStraightCounter);

            emit instance->leftRealTimePunchReadingValue(punchSpeed,
                                                         leftPunchCount,
                                                         punchPower,
                                                         userWeight,
                                                         punchTime);

        } else if (jmacAdd == rightMacAddress) {
            rightPunchCount++;
            //qWarning() << "Real-time boxing data received from Right sensor. Punch number:"
            //           << QString::number(rightPunchCount);
            QString punchType;
            if (jsonObject["fistType"].toString() == "1") {
                punchType = "Hook";
                rightHookCounter++;
            } else if (jsonObject["fistType"].toString() == "2") {
                punchType = "Uppercut";
                rightUppercutCounter++;
            } else if (jsonObject["fistType"].toString() == "3") {
                punchType = "Straight punch";
                rightStraightCounter++;
            } else {
                punchType = "Unknown";
            }
            QString punchPower = jsonObject["fistPower"].toString();
            QString punchSpeed = jsonObject["fistSpeed"].toString();
            double punchTime = jsonObject["fistOutTime"].toString().toDouble();
            QString punchDate = jsonObject["fistDate"].toString();
            QString punchDistance = jsonObject["fistDistance"].toString();

            qDebug() << "Right Punch Speed: " << punchSpeed;
            qDebug() << "Right Punch Power: " << punchPower;
            qDebug() << "Right Punch Time: " << QString::number(punchTime);
            qDebug() << "Right Punch Date: " << punchDate;
            qDebug() << "Right Punch Type: " << punchType;
            qDebug() << "Right Punch Distance: " << punchDistance;
            qDebug() << "Right Punch Count: " << QString::number(rightPunchCount);
            qDebug() << "Right Hook punch: " << QString::number(rightHookCounter);
            qDebug() << "Right Uppercut punch: " << QString::number(rightUppercutCounter);
            qDebug() << "Right Straight punch: " << QString::number(rightStraightCounter);

            emit instance->rightRealTimePunchReadingValue(punchSpeed,
                                                          rightPunchCount,
                                                          punchPower,
                                                          userWeight,
                                                          punchTime);
        }
    }

    // Release the JNI string
    env->ReleaseStringUTFChars(macAdd, nativeMacAdd);
    env->ReleaseStringUTFChars(jsonData, nativeJsonData);
}
