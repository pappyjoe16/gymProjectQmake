#include "deviceinfo.h"
#include <QBluetoothUuid>

DeviceInfo::DeviceInfo(QObject *parent)
    : QObject{parent}
{}
DeviceInfo::DeviceInfo(const QBluetoothDeviceInfo &d)
{
    device = d;
}
QString DeviceInfo::getName() const
{
    return device.name();
}

QString DeviceInfo::getAddress() const
{
#ifdef Q_OS_WIN64
    return device.deviceUuid().toString();
#else
    return device.address().toString();
#endif
}
void DeviceInfo::setDevice(const QBluetoothDeviceInfo &m_device)
{
    device = m_device;
}

QBluetoothDeviceInfo DeviceInfo::getDevice() const
{
    return device;
}
