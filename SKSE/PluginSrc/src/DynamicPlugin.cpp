#include "DynamicPlugin.h"
#include "skse64_common/Utilities.h"

namespace DynamicWeatherEffects {
	// Should Check The World Space (Possibly Cell Records?) And Return The World Space To Register If Valid
	TESForm* RegisterWorldSpace(TESForm* WorldSpace, TESForm* newWorldSpace)
	{
		// Implement Something Like Searching Through A Form List For WorldSpaces
		// And If Valid WorldSpace, Return WorldSpace, Else, Throw An Error?
        return newWorldSpace;
	}

	// Implement A Way To Register For Events
	bool RegisterEvents(VMClassRegistry* registry)
	{
		// Do Stuff
		return true;
	}

	// Implement A Way To Register Functions - Haven't Tested This Yet
	bool RegisterFunctions(VMClassRegistry* registry)
	{
		/*
		  registry->RegisterFunction(new NativeFunction1<TESForm, TESForm>("RegisterWorldSpace",
		  "DynamicWeatherWorldSpace", DynamicWeatherEffects::RegisterWorldSpace, registry));
		*/
		// Might Want Some Error Checking Here
		return true;
	}

	namespace Serialization {

		void Serialization_Revert(SKSESerializationInterface* skse)
		{
			// Do Stuff
		}


		void Serialization_Save(SKSESerializationInterface* skse)
		{
			// Do Stuff
		}


		void Serialization_Load(SKSESerializationInterface* skse)
		{
			// Do Stuff
		}

	} // namespace Serialization


} // namespace DynamicWeatherEffects