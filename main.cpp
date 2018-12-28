#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "game.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //Game fgame;
    //engine.rootContext()->setContextProperty("myGame", &fgame);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
