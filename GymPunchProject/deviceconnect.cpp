#include "deviceconnect.h"
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

DeviceConnect::DeviceConnect(QObject *parent)
    : QObject{parent}
{
    qWarning() << "Device class called.";
    discoveryAgent = new QBluetoothDeviceDiscoveryAgent();
    connect(discoveryAgent,
            SIGNAL(deviceDiscovered(const QBluetoothDeviceInfo &)),
            this,
            SLOT(addDevice(const QBluetoothDeviceInfo &)));
}

DeviceConnect::~DeviceConnect()
{
    qDeleteAll(devices);
    devices.clear();
}

QVariant DeviceConnect::name()
{
    return QVariant::fromValue(devices);
}

void DeviceConnect::startDeviceDiscovery()
{
    qDebug() << "Enter startDeviceDiscovery function 1";
#if QT_CONFIG(permissions)
    //! [permissions]
    qDebug() << "Enter startDeviceDiscovery function 2!";
    QBluetoothPermission permission{};
    qDebug() << "Enter startDeviceDiscovery function 3";
    permission.setCommunicationModes(QBluetoothPermission::Access);
    qDebug() << "Enter startDeviceDiscovery function 4!";
    switch (qApp->checkPermission(permission)) {
    case Qt::PermissionStatus::Undetermined:
        qDebug() << "Enter startDeviceDiscovery function 5";
        qApp->requestPermission(permission, this, &DeviceConnect::startDeviceDiscovery);
        qDebug() << "Enter startDeviceDiscovery function 6!";
        return;
    case Qt::PermissionStatus::Denied:
        qDebug() << "Enter startDeviceDiscovery function 7";
        qDebug() << "Bluetooth permissions not granted!";
        return;
    case Qt::PermissionStatus::Granted:
        qDebug() << "Permission Granted 8";
        break; // proceed to search
    }
    //! [permissions]
#endif // QT_CONFIG(permissions)

    qDebug() << "Enter startDeviceDiscovery function 11";
    qDeleteAll(devices);
    qDebug() << "Enter startDeviceDiscovery function 12";
    devices.clear();
    qDebug() << "Enter startDeviceDiscovery function 13";
    discoveryAgent->start();
    qWarning() << "Starting to Scan.";
}

void DeviceConnect::connectDevice(const QString &address)
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

void DeviceConnect::addDevice(const QBluetoothDeviceInfo &info)
{
    if (info.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        DeviceInfo *d = new DeviceInfo(info);
        if (d->getName().contains("HW")) {
            devices.append(d);
            qWarning() << "Discovered BLE Device " + d->getName() << "Address: " + d->getAddress();
            emit sendAddressHeart(d->getName(), d->getAddress());
        }

        if (d->getName().contains("BX100-L")) {
            devices.append(d);
            qWarning() << "Discovered BLE Device " + d->getName() << "Address: " + d->getAddress();
            emit sendAddressLeft(d->getName().remove("BX100-L"), d->getAddress());
        }

        if (d->getName().contains("BX100-R")) {
            devices.append(d);
            qWarning() << "Discovered BLE Device " + d->getName() << "Address: " + d->getAddress();
            emit sendAddressRight(d->getName().remove("BX100-R"), d->getAddress());
        }
    }
}

void DeviceConnect::serviceDiscovered(const QBluetoothUuid &gatt)
{
    if (gatt == QBluetoothUuid(QBluetoothUuid::ServiceClassUuid::HeartRate)) {
        qWarning() << "Found Heart Rate Sensor";
        m_foundHeartRateService = true;
    }
}

void DeviceConnect::serviceScanDone()
{
    qWarning() << "Service Scan Done. waiting to connect to service.";
    qInfo() << ("Service scan done.");

    if (m_service) {
        delete m_service;
        m_service = nullptr;
    }

    if (m_foundHeartRateService)
        m_service = m_control->createServiceObject(QBluetoothUuid(
                                                       QBluetoothUuid::ServiceClassUuid::HeartRate),
                                                   this);

    if (m_service) {
        connect(m_service,
                &QLowEnergyService::stateChanged,
                this,
                &DeviceConnect::serviceStateChanged);
        connect(m_service,
                &QLowEnergyService::characteristicChanged,
                this,
                &DeviceConnect::updateHeartRateValue);
        connect(m_service,
                &QLowEnergyService::descriptorWritten,
                this,
                &DeviceConnect::confirmedDescriptorWrite);
        m_service->discoverDetails();
    } else {
        qWarning() << "Heart Rate Service not found.";
    }
}

void DeviceConnect::serviceStateChanged(QLowEnergyService::ServiceState s)
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

void DeviceConnect::updateHeartRateValue(const QLowEnergyCharacteristic &c, const QByteArray &value)
{
    if (c.uuid() != QBluetoothUuid(QBluetoothUuid::CharacteristicType::HeartRateMeasurement))
        return;

    auto data = reinterpret_cast<const quint8 *>(value.constData());
    quint8 flags = *data;

    int hrvalue = 0;
    if (flags & 0x1)
        hrvalue = static_cast<int>(qFromLittleEndian<quint16>(data[1]));
    else
        hrvalue = static_cast<int>(data[1]);

    qWarning() << "HR Value:" + QString::number(hrvalue);
    emit measuringChanged(QString::number(hrvalue));
}

void DeviceConnect::confirmedDescriptorWrite(const QLowEnergyDescriptor &d, const QByteArray &value)
{
    if (d.isValid() && d == m_notificationDesc && value == QByteArray::fromHex("0000")) {
        m_control->disconnectFromDevice();
        delete m_service;
        m_service = nullptr;
    }
}

void DeviceConnect::controllerError(QLowEnergyController::Error error)
{
    qWarning() << "Controller Error: " << error << "Cannot connect to remote device.";
}

void DeviceConnect::deviceConnected()
{
    m_control->discoverServices();
}

void DeviceConnect::deviceDisconnected()
{
    qWarning() << "Remote DeviceDisconnected";
}
