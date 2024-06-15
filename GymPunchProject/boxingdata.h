#ifndef BOXINGDATA_H
#define BOXINGDATA_H

#include <QObject>

class BoxingData : public QObject
{
    Q_OBJECT
public:
    explicit BoxingData(QObject *parent = nullptr);

signals:
};

#endif // BOXINGDATA_H
