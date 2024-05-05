// bledevicelistmodel.h

#ifndef BLEDEVICELISTMODEL_H
#define BLEDEVICELISTMODEL_H

#include <QBluetoothDeviceDiscoveryAgent>
#include <QList>
#include <QObject>
#include <QStringList>

class BLEDeviceListModel : public QObject
{
    Q_OBJECT

public:
    explicit BLEDeviceListModel(QObject *parent = nullptr);
    ~BLEDeviceListModel();

    void addDevice(const QString &deviceName, const QString &deviceAddress);

signals:
    void leftDeviceDiscovered(const QString &deviceName, const QString &deviceAddress);
    void rightDeviceDiscovered(const QString &deviceName, const QString &deviceAddress);

private slots:
    void deviceDiscoveredHandler(const QBluetoothDeviceInfo &device);

private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QStringList leftDeviceNames;
    QStringList leftDeviceAddresses;
    QStringList rightDeviceNames;
    QStringList rightDeviceAddresses;
    QStringList filterDeviceNames;
};

#endif // BLEDEVICELISTMODEL_H
