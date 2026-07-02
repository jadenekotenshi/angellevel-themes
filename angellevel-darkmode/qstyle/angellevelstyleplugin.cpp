#include <QStylePlugin>
#include "angellevelstyle.h"

class AngelLevel-darkmodeStylePlugin : public QStylePlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QStyleFactoryInterface_iid FILE "angellevel.json")

public:
    QStyle *create(const QString &key) override
    {
        if (key.compare(QLatin1String("AngelLevel-darkmode"), Qt::CaseInsensitive) == 0)
            return new AngelLevel-darkmodeStyle;
        return nullptr;
    }
};

#include "angellevelstyleplugin.moc"
