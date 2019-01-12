#include "photoitem.h"

photoItem::photoItem(QObject *parent) : QObject(parent)
{
    m_willBeDeleted = false;
}

photoItem::photoItem(QObject *parent, QDir path)  : QObject(parent)
{
    m_willBeDeleted = false;

}

photoItem::photoItem(QObject *parent, QString path) : QObject(parent)
{
    m_willBeDeleted = false;

}
