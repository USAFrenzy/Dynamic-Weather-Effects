#include "skse64/PapyrusNativeFunctions.h"
#include "skse64/PluginAPI.h"

/*  ------------------------------- NOTE(Ryan) -------------------------------
    Ideally, Functions, Events, Serialization, etc.. Type Data Will Be In
    Separate Files And Then Those Files Will Be Included Here. That Way I Can
    Register The Function Types Of Those Files Under One File For Easier And
    Cleaner Maintenance And Interfacing
    -------------------------------------------------------------------------- */

namespace DynamicWeatherEffects {

	UInt32 RegisterWorldSpace(StaticFunctionTag* base, UInt32 newWorldSpace);
	bool RegisterFunctions(VMClassRegistry* registry);
	bool RegisterEvents(VMClassRegistry* registry);

	namespace Serialization {

		void Serialization_Revert(SKSESerializationInterface* skse);
		void Serialization_Save(SKSESerializationInterface* skse);
		void Serialization_Load(SKSESerializationInterface* skse);

	} // namespace Serialization

} // namespace DynamicWeatherEffects
