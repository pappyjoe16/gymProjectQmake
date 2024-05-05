// bledevicelistmodel.cpp

#include "bledevicelistmodel.h"
#include <QBluetoothLocalDevice>

BLEDeviceListModel::BLEDeviceListModel(QObject *parent)
    : QObject(parent)
{
    // Check if Bluetooth is available
    if (QBluetoothLocalDevice().isValid()) {
        discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);

        // Set the filter for device names
        // filterDeviceNames << "BX100-R" << "BX100-L";
        // discoveryAgent->setDeviceFilter(filterDeviceNames);

        // Connect the signal from the discovery agent to the handler
        connect(discoveryAgent,
                &QBluetoothDeviceDiscoveryAgent::deviceDiscovered,
                this,
                &BLEDeviceListModel::deviceDiscoveredHandler);

        // Start device discovery when the object is created
        discoveryAgent->start();
    } else {
        qWarning() << "Bluetooth not available.";
    }
}

BLEDeviceListModel::~BLEDeviceListModel()
{
    // Stop device discovery when the object is destroyed
    if (discoveryAgent) {
        discoveryAgent->stop();
        delete discoveryAgent;
    }
}

void BLEDeviceListModel::addDevice(const QString &deviceName, const QString &deviceAddress)
{
    if (deviceName.contains("BX100-L", Qt::CaseInsensitive)) {
        // Add the device to the left lists
        leftDeviceNames.append(deviceName);
        leftDeviceAddresses.append(deviceAddress);

        // Emit the signal for QML
        emit leftDeviceDiscovered(deviceName, deviceAddress);
    } else if (deviceName.contains("BX100-R", Qt::CaseInsensitive)) {
        // Add the device to the right lists
        rightDeviceNames.append(deviceName);
        rightDeviceAddresses.append(deviceAddress);

        // Emit the signal for QML
        emit rightDeviceDiscovered(deviceName, deviceAddress);
    }
}

void BLEDeviceListModel::deviceDiscoveredHandler(const QBluetoothDeviceInfo &device)
{
    // Handle the discovered device
    addDevice(device.name(), device.address().toString());
}
