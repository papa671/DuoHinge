
#import <Foundation/Foundation.h>
#import "godot_plugin.h"
#import "godot_plugin_class.h"
#import "core/config/engine.h"

PluginClass *plugin;

void duo_hinge_init() {
    plugin = memnew(PluginClass);
    Engine::get_singleton()->add_singleton(Engine::Singleton("DuoHinge", plugin));
}

void duo_hinge_deinit() {
   if (plugin) {
       memdelete(plugin);
   }
}
