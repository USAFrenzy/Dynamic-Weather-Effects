Scriptname rcm01_Quest_MCM extends SKI_ConfigBase 

; ################
; #  Versioning Of Script   #
; ################
int Function GetVersion()
	return 1;
EndFunction

; #####################
; #  Variable Forward Declarations  
; #####################
string[] presetsList


; #############
; #    Variable OIDs  
; #############
int iThirstSlider
int presetSelection
int toggleMod
int togglePuddles
int togglePuddleRunoff
int togglePuddleFreeze
int togglePuddleSublimation
int toggleDryWells
int toggleFlammableWood
int toggleIncreasedThirst

; ###############
; # Variable State Values
; ###############
float thirstSummation = 35.0
int  presetIndex = 2
bool bEnableMod = false
bool bPuddles = false
bool bPuddleRunoff = false
bool bPuddleFreeze = false
bool bPuddleSublimation = false
bool bDryWells = false
bool bFlammableWood = false
bool bIncreasedThirst = false

; Initializes The MCM Registration 
Event OnConfigInit()
	
	; assigns variable pages with how many pages we will have
	pages = new string[2]
	; This Is Where The Side Names Of The Pages Are Assigned
	pages[0] = "Main Page"
	pages[1] = "Settings"
    ; assigns variable presets with the number of presets being added
    presetsList = new string[4]
    presetsList[0] = "Script Friendly"
    presetsList[1] = "Realistic"
    presetsList[2] = "Idealistic"
    presetsList[3] = "All The Things"

EndEvent

; Handle Update Logic Here For Incremental Additions To Mod/Menu - EX:
; Event OnVersionUpdate(int version)
;	If(version >= 2)
;		Debug.Trace(self + ": Updating script to version 2")
;		Initialize New Variables, Add New Options, Update Scripts, etc
;	Endif
;EndEvent

; Essentially, The MCM Has To Redraw It's Contents Every Time A Page Is Selected
; This Is How It Will Know What To Redraw
Event OnPageReset(string page)

	; This Is The Initial Screen That Users Would See
	If (page == "")
		LoadCustomContent("test/diVktRb.png")
	Else
		UnloadCustomContent()
	Endif

	; This Is The First Actual Page When The User Selects A Side Page
	If (page == "Main Page")
		; The Display Mode Which Can Either Be Top-Bottom or Left-Right
		SetCursorFillMode(TOP_TO_BOTTOM)
		; As It Implies, Adds A Header Above Options
		AddHeaderOption("Main Options")
		toggleMod = AddToggleOption("Enable Dynamic Weather Effects", bEnableMod)
        AddEmptyOption()
        presetSelection = AddMenuOption("Presets", presetsList[presetIndex])

	Elseif (page == "Settings")
		SetCursorFillMode(LEFT_TO_RIGHT)

		AddHeaderOption("Puddle Effects")
            ; Enables Puddles To Dynamically Form Based Off Of Weather And Placement
		    togglePuddles = AddToggleOption("Enable Dynamic Puddles", bPuddles)

            SetCursorPosition(2)

            ; Enables Puddles To Stream If Overflowing Terrain Concavity		 
            togglePuddleRunoff = AddToggleOption("Enable Puddle Runoffs", bPuddleRunoff)
            
		SetCursorPosition(4)

		; Enables The Chance That Puddles Will Freeze When Hit With Ice Magic, Dragon Ice, Or Dynamically In Colder Weather 
            togglePuddleFreeze = AddToggleOption("Enable Puddle Freeze Over", bPuddleFreeze)
            
		SetCursorPosition(6)

		; Enable The Chance That Puddles Will Evaporate Into Steam On Fire Magic Or Dragon Fire            
            togglePuddleSublimation = AddToggleOption("Enable Puddle Sublimation", bPuddleSublimation)
            
            SetCursorPosition(1)

            AddHeaderOption("Arid Weather Effects")
            
		SetCursorPosition(3)

		; Wells Will Dynamically Dry Up If The Region Doesn't Experience Frequent Rain Storms And The Weather Is Too Hot
            toggleDryWells = AddToggleOption("Enable Dry Wells", bDryWells)
            
		SetCursorPosition(5)          

		; Chance To Burn If Fire Magic, Dragon Fire, Or Torched
            toggleFlammableWood = AddToggleOption("Enable Flammable Woodpiles", bFlammableWood) 
           
		SetCursorPosition(7)            

 		; If Needs Mod Enabled, Slightly Increases Thirst Rate
            toggleIncreasedThirst = AddToggleOption("Enable Increased Thirst", bIncreasedThirst)

            SetCursorPosition(9)

            ; Adds A Multiplier Slider If Increased Thirst Is Enabled
            iThirstSlider = AddSliderOption("Increased Thirst Rate", thirstSummation)
	Endif
EndEvent

Event OnOptionSelect(int option)
	If (CurrentPage == "Main Page")
    		If (option == toggleMod)
        		bEnableMod = !bEnableMod
        		SetToggleOptionValue(toggleMod, bEnableMod)
		Endif
	Elseif (CurrentPage == "Settings")
    		If (option == togglePuddles)
        		bPuddles = !bPuddles
        		SetToggleOptionValue(togglePuddles, bPuddles)
    		Elseif (option == togglePuddleRunoff)
        		bPuddleRunoff = !bPuddleRunoff
        		SetToggleOptionValue(togglePuddleRunoff, bPuddleRunoff)
    		Elseif (option == togglePuddleFreeze)
        		bPuddleFreeze = !bPuddleFreeze
        		SetToggleOptionValue(togglePuddleFreeze, bPuddleFreeze)
    		Elseif (option == togglePuddleSublimation)
        		bPuddleSublimation = !bPuddleSublimation
        		SetToggleOptionValue(togglePuddleSublimation, bPuddleSublimation)
    		Elseif (option == toggleDryWells)
        		bDryWells = !bDryWells
        		SetToggleOptionValue(toggleDryWells, bDryWells)
    		Elseif (option == toggleFlammableWood)
        		bFlammableWood = !bFlammableWood
        		SetToggleOptionValue(toggleFlammableWood, bFlammableWood)
    		Elseif (option == toggleIncreasedThirst)
        		bIncreasedThirst = !bIncreasedThirst
        		SetToggleOptionValue(toggleIncreasedThirst, bIncreasedThirst)
		Endif
	Endif
EndEvent

Event OnOptionMenuOpen(int option)
    If(option == presetSelection)
        SetMenuDialogOptions(presetsList)
        SetMenuDialogStartIndex(presetIndex)
        SetMenuDialogDefaultIndex(2)
    Endif
EndEvent

Event OnOptionMenuAccept(int option, int index)
    If(option == presetSelection)
        presetIndex = index
        SetMenuOptionValue(presetSelection, presetsList[presetIndex])
    Endif
EndEvent

Event OnOptionSliderOpen(int option)
    If (option == iThirstSlider)
        SetSliderDialogStartValue(thirstSummation)
        SetSliderDialogDefaultValue(thirstSummation)
        SetSliderDialogRange(0.00, 100.00)
        SetSliderDialogInterval(0.01)
    Endif
EndEvent

Event OnOptionSliderAccept(int option, float value)
    If (option == iThirstSlider)
        thirstSummation = value
        SetSliderOptionValue(iThirstSlider, thirstSummation)
    Endif
EndEvent