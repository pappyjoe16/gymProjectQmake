#ifndef DEVICECONNECT_H
#define DEVICECONNECT_H

#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QLowEnergyController>
#include <QObject>

#include "deviceinfo.h"

class DeviceConnect : public QObject
{
    Q_OBJECT
public:
    explicit DeviceConnect(QObject *parent = nullptr);
    ~DeviceConnect();

    QVariant name();

signals:
    void sendAddressLeft(const QVariant &name, const QVariant &address);
    void sendAddressRight(const QVariant &name, const QVariant &address);
    void sendAddressHeart(const QVariant &name, const QVariant &address);
    void measuringChanged(const QVariant &value);

public slots:
    void startDeviceDiscovery();
    void connectDevice(const QString &address);

private slots:
    void addDevice(const QBluetoothDeviceInfo &);
    void serviceDiscovered(const QBluetoothUuid &);
    void serviceScanDone();
    void controllerError(QLowEnergyController::Error);
    void deviceConnected();
    void deviceDisconnected();
    void serviceStateChanged(QLowEnergyService::ServiceState s);
    void updateHeartRateValue(const QLowEnergyCharacteristic &c, const QByteArray &value);
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &d, const QByteArray &value);

private:
    void addMeasurement(int value);

    DeviceInfo m_currentDevice;
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QList<DeviceInfo *> devices;
    QLowEnergyController *m_control;
    QLowEnergyService *m_service = nullptr;
    bool m_foundHeartRateService = false;
    bool m_foundPunchService = false;
    QLowEnergyDescriptor m_notificationDesc;
};

#endif // DEVICECONNECT_H
