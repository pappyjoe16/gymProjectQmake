#ifndef PAGESWITCHER_H
#define PAGESWITCHER_H

#include <QObject>

class Pageswitcher : public QObject
{
    Q_OBJECT
public:
    explicit Pageswitcher(QObject *parent = nullptr);
    ~Pageswitcher();
    Q_INVOKABLE void pageLoader(const QString page);

signals:
    void switchToLoginPage();
    void switchToSignupPage();
    void switchToAppPage();
    void switchToForgetPassword();
    void switchToHelpPage();
    void switchToConnectPage();
    void switchBackToConnectPage();
    void switchToQuickstart();
    void switchToBLEConnect();
    void switchBackToHeartRateDevice();
    void switchToHeartRateDevice();
    void switchToSensorReadingPage();
    void switchToRoundSeleectPage();

public slots:

};

#endif // PAGESWITCHER_H
