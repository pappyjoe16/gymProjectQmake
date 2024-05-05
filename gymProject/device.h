#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
//#include <qbluetoothglobal.h>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QBluetoothLocalDevice>
#include <QBluetoothServiceInfo>
#include <QList>
#include <QLowEnergyController>

#include <QVariant>
#include "deviceinfo.h"

class Device : public QObject
{
    Q_OBJECT
public:
    explicit Device(QObject *parent = nullptr);
    QVariant name();
    ~Device();
    Q_INVOKABLE void startDeviceDiscovery();
    Q_INVOKABLE void connectDevice(const QString &address);

signals:
    void sendAddressLeft(QVariant, QVariant);
    void sendAddressRight(QVariant, QVariant);
    void sendAddressHeart(QVariant, QVariant);
    void measuringChanged(QVariant);
    void aliveChanged();
    void statsChanged();

public slots:

private slots:
    void addDevice(const QBluetoothDeviceInfo &);

    void serviceDiscovered(const QBluetoothUuid &);
    void serviceScanDone();
    void controllerError(QLowEnergyController::Error);
    void deviceConnected();
    void deviceDisconnected();

private:
    //QLowEnergyService
    void serviceStateChanged(QLowEnergyService::ServiceState s);
    void updateHeartRateValue(const QLowEnergyCharacteristic &c, const QByteArray &value);
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &d, const QByteArray &value);

private:
    void addMeasurement(int value);
    DeviceInfo m_currentDevice;
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QList<QObject *> devices;
    QLowEnergyController *m_control;
    QLowEnergyService *m_service = nullptr;
    bool m_foundHeartRateService = false;
    QLowEnergyDescriptor m_notificationDesc;
};

#endif // DEVICE_H
