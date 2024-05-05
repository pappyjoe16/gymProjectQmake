#include "device.h"
#include <QBluetoothAddress>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QBluetoothLocalDevice>
#include <QBluetoothServiceDiscoveryAgent>
#include <QDebug>
#include <QList>
#include <QMessageBox>
#include <QString>
#include <qbluetoothuuid.h>

#if QT_CONFIG(permissions)
#include <QtCore/qcoreapplication.h>
#include <QtCore/qpermissions.h>
#endif

Device::Device(QObject *parent)
    : QObject{parent}
{
    qWarning() << "Device class called.";
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
        qDebug() << "Permission Granted";
        break; // proceed to search
    }
    //! [permissions]
#endif // QT_CONFIG(permissions)
    qDeleteAll(devices);
    devices.clear();
    discoveryAgent->start();
    qWarning() << "Starting to Scan.";
}

void Device::connectDevice(const QString &address)
{
    for (int i = 0; i < devices.size(); i++) {
        if (((DeviceInfo *) devices.at(i))->getAddress() == address) {
            m_currentDevice.setDevice(((DeviceInfo *) devices.at(i))->getDevice());
            qWarning() << "Connecting to Device";
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
            qWarning() << "Discovered BLE Device " + d->getName() << "Address: " + d->getAddress();
            emit sendAddressLeft(QString(d->getName().remove("BX100-L")), QString(d->getAddress()));
        }

        if (d->getName().contains("BX100-R")) {
            devices.append(d);
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

    qWarning() << "HR Value:" + QString::number(hrvalue);
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
    qWarning() << "Remote DeviceDisconnected";
}
