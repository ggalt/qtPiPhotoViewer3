QT += qml quick

CONFIG += c++11

SOURCES += main.cpp \
    myimageprovider.cpp \
    myapplicationwindow.cpp \
    imagefiles.cpp \
    photoitem.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#linux {
#    contains(QMAKE_HOST.arch, arm.*):{
#        #raspberry's bla bla bla

#    }else{
#        #...
#    }
#}

HEADERS += \
    myimageprovider.h \
    myapplicationwindow.h \
    imagefiles.h \
    photoitem.h
