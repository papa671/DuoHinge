#pragma once

#include "core/object/object.h"
#include "core/object/class_db.h"

class PluginClass : public Object {
    GDCLASS(DuoHinge, Object);
    
    static void _bind_methods();
    
public:
    float getAngle ();
    String getStatus ();
    void startMonitoring ();
    
    PluginClass();
    ~PluginClass();
};





