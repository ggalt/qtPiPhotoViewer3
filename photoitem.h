#ifndef PHOTOITEM_H
#define PHOTOITEM_H

#include <QObject>
#include <QString>
#include <QDir>

class photoItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString photoFileName READ photoFileName WRITE setPhotoFileName)
    Q_PROPERTY(QDir photoPath READ photoPath WRITE setPhotoPath)
    Q_PROPERTY(QDir photoFullPath READ photoFullPath WRITE setPhotoFullPath)
    Q_PROPERTY(bool willBeDeleted READ willBeDeleted WRITE setWillBeDeleted)

public:
    explicit photoItem(QObject *parent = nullptr);
    photoItem(QObject *parent, QDir path);
    photoItem(QObject *parent, QString path);

    QString photoFileName() const { return m_photoFileName; }
    void setPhotoFileName( QString fname ) { m_photoFileName = fname; }

    QDir photoPath() const { return m_photoPath; }
    void setPhotoPath(QDir d) { m_photoPath = d; }

    QDir photoFullPath() const { return m_photoFullPath; }
    void setPhotoFullPath(QDir d) { m_photoFullPath = d; }

    bool willBeDeleted() const { return m_willBeDeleted; }
    void setWillBeDeleted(bool val) { m_willBeDeleted = val; }

signals:

public slots:

private:
    QDir m_photoPath;
    QDir m_photoFullPath;
    QString m_photoFileName;
    bool m_willBeDeleted;
};

#endif // PHOTOITEM_H
