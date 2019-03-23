#ifndef IMAGEFILES_H
#define IMAGEFILES_H

#include <QObject>
#include <QStringList>
#include <QList>
#include <QString>
#include <QDir>
#include <QUrl>
#include <QVariant>
#include <QQmlEngine>
#include <QMultiMap>


#include "photoitem.h"


#include "myimageprovider.h"
#define IMAGE_BUF_SIZE 1024

class imageFiles : public QObject
{
    Q_OBJECT
public:
    explicit imageFiles(QObject *parent = nullptr);
    ~imageFiles(void);

    Q_INVOKABLE QString nextImage(void);
    Q_INVOKABLE QString previousImage(void);
    Q_INVOKABLE QString returnImagePath(void) { return photoUrlList.at(imagesShown.at(imagePointer)); }


    void ReadURLs(void);
    void setupImageProvider(QQmlEngine *eng);
    void readImageURLsFromDisk(QDir d);

signals:

public slots:

private:
    void getExifData(void);

private:
    MyImageProvider *imageProvider;

    QStringList photoUrlList;
    QMultiMap<QString, photoItem*> photoList;
    quint32 imageCount;
    quint32 imagePointer;
    QList<int> imagesShown;
    quint32 newImagesShown[IMAGE_BUF_SIZE];
    int newImagePointer;
    QDir topDir;

    QString imageDate;
    QString imageLat;
    QString imageLong;
    QString imageLocation;
};

#endif // IMAGEFILES_H
