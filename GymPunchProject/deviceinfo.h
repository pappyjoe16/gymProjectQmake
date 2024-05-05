#ifndef DEVICEINFO_H
#define DEVICEINFO_H

#include <QBluetoothAddress>
#include <QBluetoothDeviceInfo>
#include <QObject>
#include <QVariant>
//#include "deviceinfo.h"

class DeviceInfo : public QObject
{
    Q_OBJECT
public:
    explicit DeviceInfo(QObject *parent = nullptr);
    DeviceInfo(const QBluetoothDeviceInfo &d);
    QString getName() const;
    QString getAddress() const;
    void setDevice(const QBluetoothDeviceInfo &m_device);
    QBluetoothDeviceInfo getDevice() const;

signals:

private:
    QBluetoothDeviceInfo device;
};

#endif // DEVICEINFO_H
