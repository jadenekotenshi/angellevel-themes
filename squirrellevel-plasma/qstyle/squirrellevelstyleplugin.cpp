#include <QStylePlugin>
#include "squirrellevelstyle.h"

class SquirrelLevelStylePlugin : public QStylePlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QStyleFactoryInterface_iid FILE "squirrellevel.json")

public:
    QStyle *create(const QString &key) override
    {
        if (key.compare(QLatin1String("SquirrelLevel"), Qt::CaseInsensitive) == 0)
            return new SquirrelLevelStyle;
        return nullptr;
    }
};

#include "squirrellevelstyleplugin.moc"
