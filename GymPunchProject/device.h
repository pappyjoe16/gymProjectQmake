#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
//#include <qbluetoothglobal.h>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QBluetoothLocalDevice>
#include <QBluetoothServiceInfo>
#include <QJniObject>
#include <QList>
#include <QLowEnergyController>
#include <QQmlApplicationEngine>
#include <QVariant>
#include "deviceinfo.h"
#include <jni.h>

class Device : public QObject
{
    Q_OBJECT
public:
    explicit Device(QObject *parent = nullptr);
    QVariant name();
    ~Device();
    Q_INVOKABLE void startDeviceDiscovery();
    Q_INVOKABLE void connectDevice(const QString &address);
    // void javaCall();
    Q_INVOKABLE void javaConnectDevice(const QString &address);
    Q_INVOKABLE void javaDisconnectDevice();
    Q_INVOKABLE void bleDeviceDisconnected();
    static void checkPunchData(JNIEnv *env, jobject thiz, QJsonObject punchData, jstring macAdd);
    QString returnUserWeight() const;
    static Device *getInstance();
    QString getLeftMacAddress() const;
    QString getRightMacAddress() const;
    Q_INVOKABLE void getWeight(const QString &userWeight);
signals:
    void sendAddressLeft(QVariant, QVariant);
    void sendAddressRight(QVariant, QVariant);
    void sendAddressHeart(QVariant, QVariant);
    void measuringChanged(QVariant);
    void aliveChanged();
    void statsChanged();
    void leftRealTimePunchReadingValue(QVariant, QVariant, QVariant, QVariant, QVariant);
    void rightRealTimePunchReadingValue(QVariant, QVariant, QVariant, QVariant, QVariant);
    void callForWeight();

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
    QString m_leftMacAddress;
    QString m_rightMacAddress;
    static Device *instance;
    QString m_userWeight;
};

#endif // DEVICE_H
