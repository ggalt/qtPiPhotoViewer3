#ifndef MYAPPLICATIONWINDOW_H
#define MYAPPLICATIONWINDOW_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QDebug>
#include <QString>
#include <QVariant>

#include "imagefiles.h"

class myApplicationWindow : public QObject
{
    Q_OBJECT
public:
    explicit myApplicationWindow(QObject *parent = nullptr);
    ~myApplicationWindow(void);

    void Init(void);
    Q_INVOKABLE void setCursorPos(int x, int y);

signals:

public slots:
//    void setCursorPos(int x, int y);

private:
    QQmlApplicationEngine engine;
    QQmlComponent *mainComponent;
    QObject* appWindow;

    QString pictureDirectory;
    int blurValue;
    int displayDuration;
    int transitionDuration;

    imageFiles *myImages;
};

#endif // MYAPPLICATIONWINDOW_H
