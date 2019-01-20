#include <QDirIterator>
#include <QSettings>
#include <QDebug>
#include <QDateTime>
#include <QStandardPaths>
#include <QRandomGenerator>

#include "imagefiles.h"
#include "photoitem.h"

imageFiles::imageFiles(QObject *parent) : QObject(parent)
{
    imagePointer = 0;

    qsrand(QDateTime::currentMSecsSinceEpoch());
//    qsrand(5);
}

imageFiles::~imageFiles()
{

}

QString imageFiles::nextImage()
{
    if( imagePointer == 0) {
//         quint32 randNum = QRandomGenerator::global()->generate();
//        qDebug() << "Random number:" << randNum;
        imagesShown.insert(0, QRandomGenerator::global()->bounded(imageCount));
    } else {
        imagePointer--;
        if(imagePointer < 0)
            imagePointer = 0;
    }

    QString imageURL = "image://myImageProvider/"+photoUrlList.at(
                imagesShown.at(imagePointer));
//    qDebug() << imageURL << imagesShown;
    return imageURL;
}

QString imageFiles::previousImage()
{
    imagePointer++;    // NOT SURE WHY THIS NEEDS TO BE "PLUS 2" BUT IT WORKS
    if(imagePointer >= imagesShown.size())
        imagePointer = imagesShown.size()-1;

    QString imageURL = "image://myImageProvider/"+photoUrlList.at(
                imagesShown.at(imagePointer));
//    qDebug() << imageURL;
    return imageURL;
//    imagePointer+=2;    // NOT SURE WHY THIS NEEDS TO BE "PLUS 2" BUT IT WORKS
//    if(imagePointer >= imagesShown.size())
//        imagePointer = imagesShown.size()-1;

//    QString imageURL = "image://myImageProvider/"+photoUrlList.at(
//                imagesShown.at(imagePointer));
////    qDebug() << imageURL;
//    return imageURL;
}

void imageFiles::ReadURLs()
{
    photoUrlList.clear();
#ifdef Q_OS_LINUX
    //// Lenovo
    //    photoUrlList.append("/home/ggalt/Pictures/2014-summer/DSC_3264.jpg");
    //    photoUrlList.append("/home/ggalt/Pictures/2014-summer/DSC_3325.jpg");
    //    photoUrlList.append("/home/ggalt/Pictures/2014-summer/P1000417.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2014-summer/P1000504.JPG");
#ifdef Q_PROCESSOR_ARM
    readImageURLsFromDisk(QDir("/home/alarm/mnt/"));
#else
    readImageURLsFromDisk(QDir("/home/ggalt/Pictures/"));
#endif  // Q_PROCESSOR_ARM
    //// Main
//    photoUrlList.append("/home/ggalt/Pictures/2006-Summer/IMG_0430.JPG");
//    photoUrlList.append("/home/ggalt/Pictures/2006-Summer/IMG_0431.JPG");
//    photoUrlList.append("'/home/ggalt/Pictures/2015/Hawaii and California/DSC_0611.JPG'");
//    photoUrlList.append("/home/ggalt/Pictures/OldPhotos/DSC_0688.JPG");
//    readImageURLsFromDisk(QDir("/home/ggalt/Pictures/"));

    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/G0010093ww.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/G0010093.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/GOPR0116.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/GOPR0137.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/GOPR0170.JPG");

#else
    // Windows laptop
//    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_0682");
//    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_0759");
//    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_1656");
//    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_0738");
    readImageURLsFromDisk(QDir("C:/Users/ggalt66/Pictures/"));
    // Windows Desktop
//    readImageURLsFromDisk(QDir("C:/Users/George Galt/Pictures"));
#endif
    imageCount = photoUrlList.size();

}

void imageFiles::setupImageProvider(QQmlEngine *eng)
{
    imageProvider = new MyImageProvider(QQmlImageProviderBase::Image);
    eng->addImageProvider("myImageProvider", imageProvider);
}

void imageFiles::readImageURLsFromDisk(QDir d)
{
//    qDebug() << "Image URL:" << d;
    photoUrlList.clear();
    QDirIterator it(d, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        it.next();
        if( it.fileInfo().isFile() ) {
            QString entry = it.fileInfo().absoluteFilePath();
            if( entry.contains(".JPG") || entry.contains(".jpg")) {
                photoItem *p = new photoItem();
                p->setPhotoFullPath(QDir(it.fileInfo().absoluteFilePath()));
                p->setPhotoPath(QDir(it.fileInfo().absoluteDir()));
                p->setPhotoFileName(it.fileInfo().fileName());

//                qDebug() << p->photoFileName() << "--" << p->photoPath() << "--" << p->photoFullPath();

                photoUrlList.append(p->photoFullPath().absolutePath());
                photoList.insert(p->photoFileName(),p);
            }
        }
    }
    qDebug() << "Number of photos is:" << photoUrlList.count();
    qDebug() << "Standard Photo Path is:" << QStandardPaths::displayName(QStandardPaths::HomeLocation)+QStandardPaths::displayName(QStandardPaths::PicturesLocation);
    qDebug() << "Path given for photos is:" << d;
    imageCount = photoUrlList.count();
//    qDebug() << imageCount << photoUrlList.at(0);
}
