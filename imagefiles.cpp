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
    imagePointer++;
    if(imagePointer >= imagesShown.size())
        imagePointer = imagesShown.size()-1;

    QString imageURL = "image://myImageProvider/"+photoUrlList.at(
                imagesShown.at(imagePointer));
//    qDebug() << imageURL;
    return imageURL;
}

void imageFiles::ReadURLs()
{
    photoUrlList.clear();
#ifdef Q_OS_LINUX
    #ifdef Q_PROCESSOR_ARM
        readImageURLsFromDisk(QDir("/home/alarm/mnt/"));
    #else
        readImageURLsFromDisk(QDir("/home/ggalt/Pictures/"));
    #endif  // Q_PROCESSOR_ARM
    //// Main

#else
    // Windows laptop
    readImageURLsFromDisk(QDir("C:/Users/ggalt66/Pictures/"));
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

void imageFiles::getExifData(void)
{
//    imageDate = "NO DATA";
//    imageLat= "NO DATA";
//    imageLong = "NO DATA";
//    imageLocation = "NO DATA";

//    // load EXIF data from file
//    ExifData *m_exifData = exif_data_new_from_file( photoUrlList.at(imagesShown.at(imagePointer)).toLatin1().data() );

//    if( !m_exifData ) {
//        // error, either no data or file was unreadable
//        qDebug() << "File:" << photoUrlList.at(imagesShown.at(imagePointer)).toLatin1().data() << "has no EXIF data";
//        return;
//    }

//    ExifEntry *m_exifEntry = exif_content_get_entry( m_exifData->ifd[EXIF_IFD_0], EXIF_TAG_DATE_TIME);
//    char buf[1024];
//    exif_entry_get_value(m_exifEntry, buf, sizeof(buf));
//    QByteArray b(buf);
//    if( b.trimmed().length() < 0 )
//        imageDate = b;

}
