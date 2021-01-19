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
string[] pages

; ######################
; #    Variable OIDs  
; ######################

; Main Page Identifiers
int toggleMod

; Settings Page Identifiers
int thirstSlider
int presetSelection
int togglePuddles
int togglePuddleRunoff
int togglePuddleFreeze
int togglePuddleSublimation
int toggleDryWells
int toggleFlammableWood
int toggleIncreasedThirst

; Debug Page Identifiers
int toggleDebugMode

; ###########################
; # Variable State Values
; ###########################

; Main Page Variables
bool isModEnabled = false

; Settings Page Variables
float thirstSummation = 50.0
int  presetIndex = 2
bool isPuddles = false
bool isPuddleRunoff = false
bool isPuddleFreeze = false
bool isPuddleSublimation = false
bool isDryWells = false
bool isFlammableWood = false
bool isThirstIncreased = false
bool isThirstEnabled  = false

; Flags
int flag_enableThirstSlider 

; Debug Page Variables
bool isDebugEnabled = false


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

; Handle Update Logic Here For Incremental Additions To Mod/Menu - EX:
; Event OnVersionUpdate(int version)
;   if(version >= 2)
;       Debug.Trace(self + ": Updating script to version 2")
;       Initialize New Variables, Add New Options, Update Scripts, etc
;   endif
;EndEvent

;/
    Global Function For Global Variable Workaround 
    Note: While The Slider Now Toggles When Enable Increased Thirst Is
          Toggled, When You Swap Pages Or Close And Reopen The MCM, The
          Slider Is Greyed Out Until You Toggle The Thirst Option Again
    ToDo: Fix The Toggle On Close And Page Switch
/;
int Function isSliderEnabled( bool toggleValue)
        if(!toggleValue)
                flag_enableThirstSlider = OPTION_FLAG_DISABLED
            else
                flag_enableThirstSlider = OPTION_FLAG_NONE
            endif 
        return flag_enableThirstSlider
    EndFunction

; Essentially, The MCM Has To Redraw It's Contents Every Time A Page Is Selected
; This Is How It Will Know What To Redraw
Event OnPageReset(string page)

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
            toggleMod = AddToggleOption("Enable Dynamic Weather Effects", isModEnabled)
                AddEmptyOption()
                presetSelection = AddMenuOption("Presets", presetsList[presetIndex])
        
        ; ####################################################
        ; #                Settings Page                     #
        ; ####################################################
        
    elseif (page == "Settings")
        SetCursorFillMode(LEFT_TO_RIGHT)

        SetCursorPosition(0)
        AddHeaderOption("Puddle Effects")

            SetCursorPosition(2)
            ; Enables Puddles To Dynamically Form Based Off Of Weather And Placement
            togglePuddles = AddToggleOption("Enable Dynamic Puddles", isPuddles)

            SetCursorPosition(4)
            ; Enables Puddles To Stream if Overflowing Terrain Concavity         
            togglePuddleRunoff = AddToggleOption("Enable Puddle Runoffs", isPuddleRunoff)
            
            SetCursorPosition(6)
            ; Enables The Chance That Puddles Will Freeze When Hit With Ice Magic, Dragon Ice, Or Dynamically In Colder Weather 
            togglePuddleFreeze = AddToggleOption("Enable Puddle Freeze Over", isPuddleFreeze)
            
            SetCursorPosition(8)
            ; Enable The Chance That Puddles Will Evaporate Into Steam On Fire Magic Or Dragon Fire            
            togglePuddleSublimation = AddToggleOption("Enable Puddle Sublimation", isPuddleSublimation)
            
         SetCursorPosition(1)
         AddHeaderOption("Arid Weather Effects")
            
            SetCursorPosition(3)
            ; Wells Will Dynamically Dry Up if The Region Doesn't Experience Frequent Rain Storms And The Weather Is Too Hot
            toggleDryWells = AddToggleOption("Enable Dry Wells", isDryWells)
            
            SetCursorPosition(5)          
            ; Chance To Burn if Fire Magic, Dragon Fire, Or Torched
            toggleFlammableWood = AddToggleOption("Enable Flammable Woodpiles", isFlammableWood) 
           
            SetCursorPosition(7)            
            ; if Needs Mod Enabled, Slightly Increases Thirst Rate
            toggleIncreasedThirst = AddToggleOption("Enable Increased Thirst", isThirstIncreased)

            SetCursorPosition(9)
            ; Adds A Multiplier Slider if Increased Thirst Is Enabled 
            int verifiedFlag = isSliderEnabled(isThirstEnabled)          
            SetOptionFlags(thirstSlider, verifiedFlag)
            thirstSlider = AddSliderOption("Increased Thirst Rate", thirstSummation, "{2}", flag_enableThirstSlider)
        
        ; ####################################################
        ; #                  Debug Page                      #
        ; ####################################################
    elseif (page == "Debug")
        SetCursorFillMode(TOP_TO_BOTTOM)
        
            AddHeaderOption("Debug Settings")
            toggleDebugMode = AddToggleOption("Enable Debugging", isDebugEnabled) 
    endif
EndEvent

Event OnOptionSelect(int option)
        ; ####################################################
        ; #                   Main Page                      #
        ; ####################################################
    if (CurrentPage == "Main Page")
            if (option == toggleMod)
                isModEnabled = !isModEnabled
                SetToggleOptionValue(toggleMod, isModEnabled)
        endif
        ; ####################################################
        ; #                Settings Page                     #
        ; ####################################################     
    elseif (CurrentPage == "Settings")
            if (option == togglePuddles)
                isPuddles = !isPuddles
                SetToggleOptionValue(togglePuddles, isPuddles)
            elseif (option == togglePuddleRunoff)
                isPuddleRunoff = !isPuddleRunoff
                SetToggleOptionValue(togglePuddleRunoff, isPuddleRunoff)
            elseif (option == togglePuddleFreeze)
                isPuddleFreeze = !isPuddleFreeze
                SetToggleOptionValue(togglePuddleFreeze, isPuddleFreeze)
            elseif (option == togglePuddleSublimation)
                isPuddleSublimation = !isPuddleSublimation
                SetToggleOptionValue(togglePuddleSublimation, isPuddleSublimation)
            elseif (option == toggleDryWells)
                isDryWells = !isDryWells
                SetToggleOptionValue(toggleDryWells, isDryWells)
            elseif (option == toggleFlammableWood)
                isFlammableWood = !isFlammableWood
                SetToggleOptionValue(toggleFlammableWood, isFlammableWood)
            elseif (option == toggleIncreasedThirst)
                isThirstIncreased = !isThirstIncreased
                    SetToggleOptionValue(toggleIncreasedThirst, isThirstIncreased)
                int updateFlag = isSliderEnabled(isThirstIncreased)
                    SetOptionFlags(thirstSlider, updateFlag)
            endif
        ; ####################################################
        ; #                  Debug Page                      #
        ; #################################################### 
    elseif (CurrentPage == "Debug")
        if (option == toggleDebugMode)
            isDebugEnabled =!isDebugEnabled
            SetToggleOptionValue(toggleDebugMode, isDebugEnabled)
        endif   
    endif
EndEvent

        ; ####################################################
        ; #           Drop-Down Menu Functions               #
        ; #################################################### 
Event OnOptionMenuOpen(int option)
    if(option == presetSelection)
        SetMenuDialogOptions(presetsList)
        SetMenuDialogStartIndex(presetIndex)
        SetMenuDialogDefaultIndex(2)
    endif
EndEvent

Event OnOptionMenuAccept(int option, int index)
    if(option == presetSelection)
        presetIndex = index
        SetMenuOptionValue(presetSelection, presetsList[presetIndex])
    endif
EndEvent


        ; ####################################################
        ; #              Slider Menu Functions               #
        ; ####################################################
Event OnOptionSliderOpen(int option)
    if (option == thirstSlider)
        SetSliderDialogStartValue(thirstSummation)
        SetSliderDialogDefaultValue(50)
        SetSliderDialogRange(0.00, 100.00)
        SetSliderDialogInterval(0.01)
    endif
EndEvent

Event OnOptionSliderAccept(int option, float value)
    if (option == thirstSlider)
        thirstSummation = value
        SetSliderOptionValue(thirstSlider, thirstSummation, "{2}")
    endif
EndEvent
