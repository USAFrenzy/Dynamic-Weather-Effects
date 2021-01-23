Scriptname rcm01_Quest_MCM extends SKI_ConfigBase


; ##########################
; #  Versioning Of Script
; ##########################
int Function GetVersion()
    return 1;
EndFunction

; ##################################
; #  Variable Forward Declarations  
; ##################################
string[] presetsList

; ###########################
; # Variable State Values
; ###########################

; Main Page Variables
bool isModEnabled

; Settings Page Variables
int  presetIndex
bool isPuddles
bool isPuddleRunoff
bool isPuddleFreeze
bool isPuddleSublimation

bool isAridOptionEnabled
bool isDryWells
bool isFlammableWood
bool isThirstIncreased
bool isThirstIncreasedNeeds
bool isThirstEnabled
float thirstSummation = 15.0
float thirstSummationAction = 15.0
float thirstSummationNeeds = 15.0

; Debug Page Variables
bool isDebugEnabled

; Initializes The MCM Registration 
Event OnConfigInit()
    ; Give A Little Time For Everything To "Warm Up"
    Utility.Wait(5)
    Debug.Notification("Initializing Dynamic Weather Effects")
    ; assigns variable pages with how many pages we will have
    pages = new string[3]
    pages[0] = "Main Page"
    pages[1] = "Settings"
    pages[2] = "Debug"
    ; assigns variable presetsList with the number of presets being added
    presetsList = new string[4]
    presetsList[0] = "Script Friendly"
    presetsList[1] = "Realistic"
    presetsList[2] = "Idealistic"
    presetsList[3] = "All The Things"
EndEvent

Event OnConfigRegister()
    Debug.Notification("Dynamic Weather Effects Registered Successfully")
EndEvent

Function OnPageReset(string page)
 ; This Is The Initial Screen That Users Would See
    if (page == "")
        LoadCustomContent("")
    Else
        UnloadCustomContent()
    endif

        ; ####################################################
        ; #                   Main Page                      #
        ; ####################################################
        
    if (page == "Main Page")
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddHeaderOption("Main Options")
            AddToggleOptionST("EnableMod", "Enable Dynamic Weather Effects", isModEnabled)
                AddEmptyOption()
                AddMenuOptionST("PresetSelection","Presets", presetsList[presetIndex])

        ; ####################################################
        ; #                Settings Page                     #
        ; ####################################################
        
    elseif (page == "Settings")
        SetCursorFillMode(LEFT_TO_RIGHT)

        SetCursorPosition(0)
        AddHeaderOption("Puddle Effects")

            SetCursorPosition(2)
            ; Enables Puddles To Dynamically Form Based Off Of Weather And Placement
            AddToggleOptionST("EnableDynamicPuddles","Enable Dynamic Puddles", isPuddles)

            SetCursorPosition(4)
            ; Enables Puddles To Stream if Overflowing Terrain Concavity         
            if(isPuddles)
                AddToggleOptionST("EnablePuddleRunoffs","Enable Puddle Runoffs", isPuddleRunoff, OPTION_FLAG_NONE)
            else
                AddToggleOptionST("EnablePuddleRunoffs","Enable Puddle Runoffs", isPuddleRunoff, OPTION_FLAG_DISABLED)
            endif

            SetCursorPosition(6)
            ; Enables The Chance That Puddles Will Freeze When Hit With Ice Magic, Dragon Ice, Or Dynamically In Colder Weather 
            if(isPuddles)
                AddToggleOptionST("EnablePuddleFreezing","Enable Puddle Freezing", isPuddleFreeze, OPTION_FLAG_NONE)
            else
                AddToggleOptionST("EnablePuddleFreezing","Enable Puddle Freezing", isPuddleFreeze, OPTION_FLAG_DISABLED)
            endif

            SetCursorPosition(8)
            ; Enable The Chance That Puddles Will Evaporate Into Steam On Fire Magic Or Dragon Fire            
            if(isPuddles)
                AddToggleOptionST("EnablePuddleSublimation","Enable Puddle Sublimation", isPuddleSublimation, OPTION_FLAG_NONE)
            else 
                AddToggleOptionST("EnablePuddleSublimation","Enable Puddle Sublimation", isPuddleSublimation, OPTION_FLAG_DISABLED)
            endif

            SetCursorPosition(1)
            AddHeaderOption("Arid Weather Effects")
            
            SetCursorPosition(3)
            AddToggleOptionST("EnableAridWeatherEffects", "Enables Arid/Warm Weather Effects",  isAridOptionEnabled)
            
            SetCursorPosition(5)            
            AddEmptyOption()

            SetCursorPosition(7)
            AddHeaderOption("Basic Arid Effects")
            
            ; Honestly, Could Go About This WHOLE Section Just By Doing ONE if else Switch And Set The Cursor Position For Each Option In That Switch...
            SetCursorPosition(9)
            ; Wells Will Dynamically Dry Up if The Region Doesn't Experience Frequent Rain Storms And The Weather Is Too Hot
            if(isAridOptionEnabled)
                AddToggleOptionST("EnableDryWells","Enable Dry Wells", isDryWells, OPTION_FLAG_NONE)
            else
                AddToggleOptionST("EnableDryWells","Enable Dry Wells", isDryWells, OPTION_FLAG_DISABLED)
            endif

            SetCursorPosition(11)          
            ; Chance To Burn if Fire Magic, Dragon Fire, Or Torched
            if(isAridOptionEnabled)
                AddToggleOptionST("EnableFlammableWoodPiles","Enable Flammable Woodpiles", isFlammableWood, OPTION_FLAG_NONE) 
           else
                AddToggleOptionST("EnableFlammableWoodPiles","Enable Flammable Woodpiles", isFlammableWood, OPTION_FLAG_DISABLED) 
            endif

            SetCursorPosition(13)            
            AddHeaderOption("Thirst Rating Settings")

            SetCursorPosition(15)            
            if(isAridOptionEnabled)
                AddToggleOptionST("EnableIncreasedThirst","Enable Increased Thirst", isThirstIncreased, OPTION_FLAG_NONE)
            else
                AddToggleOptionST("EnableIncreasedThirst","Enable Increased Thirst", isThirstIncreased, OPTION_FLAG_DISABLED)
            endif

             SetCursorPosition(17)            
            ; if Needs Mod Enabled, Slightly Increases Thirst Rate
            if(isAridOptionEnabled)
                AddToggleOptionST("EnableIncreasedThirstForNeeds","Enable Increased Thirst For Needs Mods", isThirstIncreasedNeeds, OPTION_FLAG_NONE)
            else
                AddToggleOptionST("EnableIncreasedThirstForNeeds","Enable Increased Thirst For Needs Mods", isThirstIncreasedNeeds, OPTION_FLAG_DISABLED)
            endif

            SetCursorPosition(19)
            ; Adds A Multiplier Slider if Increased Thirst Is Enabled
                if (isAridOptionEnabled)
                    AddSliderOptionST("EnableIncreasedThirstRating","Base Increased Thirst Multiplier", thirstSummation, "{2}", OPTION_FLAG_NONE)
                else
                    AddSliderOptionST("EnableIncreasedThirstRating","Base Increased Thirst Multiplier", thirstSummation, "{2}", OPTION_FLAG_DISABLED)
                endif

             SetCursorPosition(21)
            ; Adds A Multiplier Slider if Increased Thirst Is Enabled
                if (isAridOptionEnabled)
                    AddSliderOptionST("EnableIncreasedThirstRatingAction","Increased Thirst For Actions Multiplier", thirstSummationAction, "{2}", OPTION_FLAG_NONE)
                else
                    AddSliderOptionST("EnableIncreasedThirstRatingAction","Increased Thirst For Actions Multiplier", thirstSummationAction, "{2}", OPTION_FLAG_DISABLED)
                endif

            SetCursorPosition(23)
            ; Adds A Multiplier Slider if Increased Thirst Is Enabled
                if (isAridOptionEnabled)
                    AddSliderOptionST("EnableIncreasedThirstRatingForNeeds","Increased Thirst Needs Mod Multiplier", thirstSummationNeeds, "{2}", OPTION_FLAG_NONE)
                else
                    AddSliderOptionST("EnableIncreasedThirstRatingForNeeds","Increased Thirst Needs Mod Multiplier", thirstSummationNeeds, "{2}", OPTION_FLAG_DISABLED)
                endif
        ; ####################################################
        ; #                  Debug Page                      #
        ; ####################################################
    elseif (page == "Debug")
        SetCursorFillMode(TOP_TO_BOTTOM)
        
            AddHeaderOption("Debug Settings")
            AddToggleOptionST("EnableDebugging","Enable Debugging", isDebugEnabled) 
    endif
EndFunction

State EnableMod
    Event OnHighlightST()
        SetInfoText("Toggle To Enable Or Disable Dynamic Weather Effects")
    EndEvent

    Event OnDefaultST()
		isModEnabled = false
		SetToggleOptionValueST(isModEnabled)
	EndEvent

    Event OnSelectST()
        isModEnabled = !isModEnabled
        SetToggleOptionValueST(isModEnabled)
            if(!isModEnabled)
                Debug.MessageBox("Dynamic Weather Effects Disabled\nPlease Close MCM For Changes To Take Effect.")
            else 
                Debug.MessageBox("Dynamic Weather Effects Enabled\nPlease Close MCM For Changes To Take Effect.")
            endif
    EndEvent
EndState

State PresetSelection
    Event OnHighlightST()
        SetInfoText("Select A Pre-Configured Preset To Load Settings From\n These Settings Can Always Be Changed If Desired")
    EndEvent

    Event OnMenuOpenSt()
        SetMenuDialogStartIndex(presetIndex)
        SetMenuDialogDefaultIndex(presetIndex)
        SetMenuDialogOptions(presetsList)
    EndEvent

    Event OnDefaultST()
        presetIndex = 2
        SetMenuOptionValueST(presetsList[presetIndex])
    EndEvent

    Event OnMenuAcceptST(int index)
        presetIndex = index
        SetMenuOptionValueST(presetsList[presetIndex])
    EndEvent
EndState

; ToDo: Add Conditions On When Puddles Should Appear
State EnableDynamicPuddles 
    Event OnHighlightST()
        SetInfoText("Enables/Disables Allowing Dynamic Puddles To Appear In Game")
    EndEvent

    Event OnDefaultST()
        isPuddles = false
        SetToggleOptionValueST(isPuddles)
	EndEvent

    Event OnSelectST()
        isPuddles = !isPuddles
        SetToggleOptionValueST(isPuddles)
            if(!isPuddles)
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnablePuddleRunoffs")
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnablePuddleFreezing")
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnablePuddleSublimation")
            else 
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnablePuddleRunoffs")
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnablePuddleFreezing")
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnablePuddleSublimation")
            endif
    EndEvent
EndState

State EnableAridWeatherEffects 
    Event OnHighlightST()
        SetInfoText("Enables/Disables The Below Arid/Warm Weather Effects")
    EndEvent

    Event OnDefaultST()
        isAridOptionEnabled = false
        SetToggleOptionValueST(isAridOptionEnabled)
	EndEvent

    Event OnSelectST() 
        isAridOptionEnabled = !isAridOptionEnabled
        SetToggleOptionValueST(isAridOptionEnabled)
            ; For All Arid Toggle Options ------------------------------------------------------------
            if(!isAridOptionEnabled) 
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnableDryWells")
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnableFlammableWoodPiles")
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnableIncreasedThirst")
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnableIncreasedThirstForNeeds")
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnableIncreasedThirstRating")
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnableIncreasedThirstRatingForNeeds")
                SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EnableIncreasedThirstRatingAction")
            else 
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnableDryWells")
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnableFlammableWoodPiles")
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnableIncreasedThirst")
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnableIncreasedThirstForNeeds")
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnableIncreasedThirstRating")
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnableIncreasedThirstRatingForNeeds")
                SetOptionFlagsST(OPTION_FLAG_NONE, false, "EnableIncreasedThirstRatingAction")
            endif
    EndEvent
EndState



; ToDo: Add Conditions For Appearance
State EnablePuddleRunoffs 
    Event OnHighlightST()
        SetInfoText("If Dynamic Puddles Is Enabled, Allows The Ability For Puddles To Overflow Terrain In Runoffs")
    EndEvent

    Event OnDefaultST()
            isPuddleRunoff = false
            SetToggleOptionValueST(isPuddleRunoff)
	EndEvent

    Event OnSelectST()
        isPuddleRunoff = !isPuddleRunoff
        SetToggleOptionValueST(isPuddleRunoff)
    EndEvent
EndState

; ToDo: Add Conditions For Freezing
State EnablePuddleFreezing  
    Event OnHighlightST()
        SetInfoText("If Dynamic Puddles Is Enabled, Allows The Ability For Puddles To Freeze Over")
    EndEvent

    Event OnDefaultST()
            isPuddleFreeze = false
            SetToggleOptionValueST(isPuddleFreeze)
	EndEvent

    Event OnSelectST()
        isPuddleFreeze = !isPuddleFreeze
        SetToggleOptionValueST(isPuddleFreeze)        
    EndEvent
EndState

State EnablePuddleSublimation  
    Event OnHighlightST()
        SetInfoText("If Dynamic Puddles Is Enabled, Allows For The Ability Of Puddles To Evaporate And, Under Intense Heat, Transition To Steam")
    EndEvent

    Event OnDefaultST()
        isPuddleSublimation = false
        SetToggleOptionValueST(isPuddleSublimation)
	EndEvent

    Event OnSelectST()
        isPuddleSublimation = !isPuddleSublimation
        SetToggleOptionValueST(isPuddleSublimation)
    EndEvent
EndState

State EnableDryWells  
    Event OnHighlightST()
        SetInfoText("Enables The Level Of Water In Wells To Drop\nRecommended Use With NEEDs Type Mods")
    EndEvent

    Event OnDefaultST()
        isDryWells = false
        SetToggleOptionValueST(isDryWells)
	EndEvent

    Event OnSelectST()
        isDryWells = !isDryWells
        SetToggleOptionValueST(isDryWells)
    EndEvent
EndState

;/
    ToDo:
    - Add Options For Needs Mods, Such As Frostfall And Campfire
    - Add Ability For Warmth Rating From Burning Woodpiles
    - Add Moisture, Dryness, And Something Like Available O2 Rating
    - More To Come
/;




State EnableFlammableWoodPiles
    Event OnHighlightST()
        SetInfoText("Enables The Ability For Wood Piles To Be Burnable")
    EndEvent

    Event OnDefaultST()
        isFlammableWood = false
        SetToggleOptionValueST(isFlammableWood)
	EndEvent

    Event OnSelectST()
        isFlammableWood = !isFlammableWood
        SetToggleOptionValueST(isFlammableWood)
    EndEvent
EndState

State EnableIncreasedThirst
    Event OnHighlightST()
        SetInfoText("Enables Increased Thirst Rating In Arid And Warmer Environments\nConfigurable For Needs Mods And Actions, Such As Sprinting Increases Thirst")
    EndEvent

    Event OnDefaultST()
        isThirstIncreased = false
        SetToggleOptionValueST(isThirstIncreased)
	EndEvent

    Event OnSelectST()
        isThirstIncreased = !isThirstIncreased
        SetToggleOptionValueST(isThirstIncreased)
        if(isThirstIncreased && isThirstIncreasedNeeds)
            Debug.MessageBox("You Have Both The Base Mod's Increased Thirst And The Needs Compatible Thirst Enabled.\n Recommend Disabling One Unless You Want Death By Hardcore Dehydration!\n(Optionally, You Could Leave Both On And Adjust The Base Mod's Sliders To A Low Value)")
        endif
    EndEvent
EndState

State EnableIncreasedThirstForNeeds
    Event OnHighlightST()
        SetInfoText("Enables Increased Thirst Rating For Needs Type Mods\nIf Enabled, Disbables This Mod's Base Thirst Muliplier In Favor Of Needs Type Multiplier")
    EndEvent

    Event OnDefaultST()
        isThirstIncreasedNeeds = false
        SetToggleOptionValueST(isThirstIncreasedNeeds)
	EndEvent
    
    Event OnSelectST()
        isThirstIncreasedNeeds = !isThirstIncreasedNeeds
        SetToggleOptionValueST(isThirstIncreasedNeeds)
        if(isThirstIncreased && isThirstIncreasedNeeds)
            Debug.MessageBox("You Have Both The Base Mod's Increased Thirst And The Needs Compatible Thirst Enabled.\n Recommend Disabling One Unless You Want Death By Hardcore Dehydration!\n(Optionally, You Could Leave Both On And Adjust The Base Mod's Sliders To A Low Value)")
        endif
    EndEvent
EndState


;/
    FIX: Aesthetically, After Selecting Value In Slider, Float Displays As Int On MCM
         On Reopening Slider, Displays As Float Value Again -> Fix For Consistency
/;
State EnableIncreasedThirstRating
    Event OnHighlightST()
        SetInfoText("Locational Slider For Thirst Rating Increase For This Mod\nDoesn't Take Into Effect Needs Mods Or Action Based Thirst Rating \n[See Other Sliders For Those Rating Settings]")
    EndEvent

    Event OnSliderOpenST()
        SetSliderDialogStartValue(thirstSummation)
		SetSliderDialogDefaultValue(50.00)
		SetSliderDialogRange(0.00, 500.00)
		SetSliderDialogInterval(0.01)
    EndEvent

    Event OnDefaultST()
        thirstSummation = 50.00
        SetSliderOptionValueST(thirstSummation)
	EndEvent

    Event OnSliderAcceptST(float sliderValue)
        thirstSummation = sliderValue
        SetSliderOptionValueST(thirstSummation, "{2}")
    EndEvent
EndState

State EnableIncreasedThirstRatingAction
    Event OnHighlightST()
        SetInfoText("Action Based Slider For Thirst Rating Increase For This Mod\n Set To 0 To Disable, Otherwise, Adds A Thirst Rating To Actions Such As Running, Swimming, Attacking, etc")
    EndEvent

    Event OnSliderOpenST()
        SetSliderDialogStartValue(thirstSummationAction)
		SetSliderDialogDefaultValue(15.00)
		SetSliderDialogRange(0.00, 500.00)
		SetSliderDialogInterval(0.01)
    EndEvent

    Event OnDefaultST()

        thirstSummationAction = 15.00
        SetSliderOptionValueST(thirstSummationAction)
	EndEvent

    Event OnSliderAcceptST(float sliderValue)
        thirstSummationAction = sliderValue
        SetSliderOptionValueST(thirstSummationAction, "{2}")
    EndEvent
EndState

State EnableIncreasedThirstRatingForNeeds
    Event OnHighlightST()
        SetInfoText("Slider For Thirst Rating Increase For Needs Mods\n Set To 0 To Disable, Otherwise, Adds A Thirst Rating Multiplier To Needs Type Thirst System")
    EndEvent

    Event OnSliderOpenST()
        SetSliderDialogStartValue(thirstSummationNeeds)
		SetSliderDialogDefaultValue(15.00)
		SetSliderDialogRange(0.00, 500.00)
		SetSliderDialogInterval(0.01)
    EndEvent

    Event OnDefaultST()
        thirstSummationNeeds = 15.00
        SetSliderOptionValueST(thirstSummationNeeds)
	EndEvent

    Event OnSliderAcceptST(float sliderValue)
        thirstSummationNeeds = sliderValue
        SetSliderOptionValueST(thirstSummationNeeds, "{2}")
    EndEvent
EndState

State EnableDebugging
    Event OnHighlightST()
        SetInfoText("Enables/Disables Debugging Options")
    EndEvent

    Event OnDefaultST()
        isDebugEnabled = false
        SetToggleOptionValueST(isDebugEnabled)
    EndEvent

    Event OnSelectST()
        isDebugEnabled = !isDebugEnabled
        SetToggleOptionValueST(isDebugEnabled)
            if(isDebugEnabled)
                Utility.SetINIBool("bRandomSetting:Papyrus", true)
                Utility.SetINIBool("bRandomSetting:Papyrus", true)
                Utility.SetINIBool("bRandomSetting:Papyrus", true)
                Utility.SetINIBool("bRandomSetting:Papyrus", true)

                    Debug.MessageBox("Debugging Disabled")
                        Debug.Notification(Utility.GetINIBool("bEnableLogging:Papyrus"))
                        Debug.Notification(Utility.GetINIBool("bEnableNotification:Papyrus"))
                        Debug.Notification(Utility.GetINIBool("bLoadDebugInformation:Papyrus"))
                        Debug.Notification(Utility.GetINIBool("bEnableProfiling:Papyrus"))
            else
                Utility.SetINIBool("bEnableLogging:Papyrus", false)
                Utility.SetINIBool("bEnableNotification:Papyrus", false)
                Utility.SetINIBool("bLoadDebugInformation:Papyrus", false)
                Utility.SetINIBool("bEnableProfiling:Papyrus", false)

                    Debug.MessageBox("Debugging Enabled")
                        Debug.Notification(Utility.GetINIBool("bEnableLogging:Papyrus"))
                        Debug.Notification(Utility.GetINIBool("bEnableNotification:Papyrus"))
                        Debug.Notification(Utility.GetINIBool("bLoadDebugInformation:Papyrus"))
                        Debug.Notification(Utility.GetINIBool("bEnableProfiling:Papyrus"))
            endif
    EndEvent
EndState