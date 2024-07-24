#include "pageswitcher.h"
#include <QDebug>



Pageswitcher::Pageswitcher(QObject *parent)
    : QObject{parent}
{
    qDebug() << " I am created";
}

Pageswitcher::~Pageswitcher()
{
     qDebug() << " I am deconstructed";
}

void Pageswitcher::pageLoader(const QString page)
{
    if (page == "login"){
        emit switchToLoginPage();
    }else if(page == "signup"){
        emit switchToSignupPage();
    }else if(page == "forgetPassword"){
        emit switchToForgetPassword();
    }else if(page == "backHome"){
        emit switchToAppPage();
    }else if(page == "helpPage"){
        emit switchToHelpPage();
    }else if(page == "connectPage"){
        emit switchToConnectPage();
    }else if(page == "backToConnect"){
        emit switchBackToConnectPage();
    }else if(page == "backToQuickstart"){
        emit switchToQuickstart();
    } else if (page == "backToBLEConnect") {
        emit switchToBLEConnect();
    } else if (page == "backToHeartRateDevice") {
        emit switchBackToHeartRateDevice();
    } else if (page == "ToHeartRateDevice") {
        emit switchToHeartRateDevice();
    } else if (page == "ToSensorReadingPage") {
        emit switchToSensorReadingPage();
    } else if (page == "roundselect") {
        emit switchToRoundSeleectPage();
    }
}
