#include "src/DynamicPlugin.h"
#include "skse64_common/Utilities.h"

namespace DynamicWeatherEffects {
	// Should Check The World Space (Possibly Cell Records?) And Return The World Space To Register If Valid
	float RegisterWorldSpace(StaticFunctionTag* base, UInt32 newWorldSpace)
	{
		// Implement Something Like Searching Through A Form List For WorldSpaces
		// And If Valid WorldSpace, Return WorldSpace, Else, Throw An Error?
	}


	// Implement A Way To Register Functions - As static_cast Is Stating, As This Is Right Now, It Won't Work
	bool RegisterFunctions(VMClassRegistry* registry)
	{
		// registry->RegisterFunction(static_cast<IFunction*>(DynamicWeatherEffects::RegisterWorldSpace));

		return true;
	}
} // namespace DynamicWeatherEffects