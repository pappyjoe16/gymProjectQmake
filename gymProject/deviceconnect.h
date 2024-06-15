#ifndef DEVICECONNECT_H
#define DEVICECONNECT_H

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

class DeviceConnect : public QObject
{
    Q_OBJECT
public:
    explicit DeviceConnect(QObject *parent = nullptr);
    QVariant name();
    ~DeviceConnect();

signals:
    void sendAddressLeft(QVariant, QVariant);
    void sendAddressRight(QVariant, QVariant);
    void sendAddressHeart(QVariant, QVariant);
    void measuringChanged(QVariant);
    void aliveChanged();
    void statsChanged();

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
    bool m_foundPunchService = false;
    QLowEnergyDescriptor m_notificationDesc;
};

#endif // DEVICECONNECT_H
