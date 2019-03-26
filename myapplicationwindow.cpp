#include "myapplicationwindow.h"
#include <QStandardPaths>
#include <QDir>
#include <QSettings>
#include <QVariant>
#include <QQuickView>
#include <QCursor>

#define DISPLAY_DURATION    10 * 1000
#define TRANSITION_DURATION 4 * 1000
#define BLUR_VALUE          99

myApplicationWindow::myApplicationWindow(QObject *parent) : QObject(parent)
{

}

myApplicationWindow::~myApplicationWindow()
{
#ifdef Q_OS_WIN
    QSettings settings(QSettings::IniFormat, QSettings::UserScope,
                       "GeorgeGalt", "qtPiPhotoViewer3");
#else
    QSettings settings;
#endif
    settings.setValue("blurValue", QVariant(blurValue));
    settings.setValue("displayDuration", QVariant(displayDuration));
    settings.setValue("pictureDirectory", QVariant(pictureDirectory));
    settings.setValue("transitionDuration", QVariant(transitionDuration));
}

void myApplicationWindow::Init()
{
//    mainComponent = new QQmlComponent(&engine, "main.qml");
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    appWindow = engine.rootObjects().first();

#ifdef Q_OS_WIN
    QSettings settings(QSettings::IniFormat, QSettings::UserScope,
                       "GeorgeGalt", "qtPiPhotoViewer3");
#else
    QSettings settings;
#endif

    QString pictureHomeDir = QStandardPaths::standardLocations(
                QStandardPaths::PicturesLocation).first();

   if( settings.contains("pictureDirectory")) {
        qDebug() << "No picture Directory available, we should ask for one";
        // load QML File Dialog and select directory
        QVariant returnedValue;
        QVariant msg = pictureHomeDir;
        QMetaObject::invokeMethod(appWindow, "selectPhotoDirectory",
                Q_RETURN_ARG(QVariant, returnedValue),
                Q_ARG(QVariant, msg));
        qDebug() << "Returned value:" << returnedValue;
        pictureDirectory = settings.value("pictureDirectory", pictureHomeDir).toString();
   } else {
        pictureDirectory = settings.value("pictureDirectory", pictureHomeDir).toString();
    }

    blurValue = settings.value("blurValue",BLUR_VALUE).toInt();
    displayDuration = settings.value("displayDuration", DISPLAY_DURATION).toInt();
    transitionDuration = settings.value("transitionDuration", TRANSITION_DURATION).toInt();
//    QQuickView *v = new QQuickView(&engine,0);
//    v->setScreen();

    QDir d(pictureDirectory);

    myImages = new imageFiles(this);
    myImages->setupImageProvider(&engine);
    myImages->readImageURLsFromDisk(d);
//    myImages->ReadURLs();
    engine.rootContext()->setContextProperty("myImages", myImages);
    engine.rootContext()->setContextProperty("myAppWindow", this);
    appWindow->setProperty("showImageDuration", displayDuration);
    appWindow->setProperty("transitionDuration", transitionDuration);
    appWindow->setProperty("blurValue",blurValue);
    appWindow->setProperty("pictureHome", pictureHomeDir);


    QVariant returnedValue;
    QVariant msg = "BlankImage";
    QMetaObject::invokeMethod(appWindow, "setImageState",
            Q_RETURN_ARG(QVariant, returnedValue),
            Q_ARG(QVariant, msg));
}

void myApplicationWindow::setCursorPos(int x, int y)
{
    QCursor c;
    c.setPos(60,60);
    c.setPos(x,y);
}
