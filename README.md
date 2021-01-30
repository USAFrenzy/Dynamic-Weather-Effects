# Dynamic-Weather-Effects
Welcome To The Mod Page!

This is a WIP project that, when done, will add dynamic weather effects to the world of Skyrim SE.

The Framework For The Plugin Can Be Found Over At [Dynamic Weather Effects Framework](https://github.com/USAFrenzy/DynamicWeatherEffects.git)
- If Downloading This Mod To Work On The Framework And Source In Tandem - Make Sure You Do The Following:
    - Run ```git clone https://github.com/USAFrenzy/DynamicWeatherEffects-WIP-.git```
    - Then ```cd DyanmicWeatherEffects-WIP-```
    - Run ```git submodule update --init --recursive```
    - Run ```git submodule update --recursive --remote```
- This Way You'll See The Updated Framework In Your Download Without Having To Go Clone That Repo
    - The Plugin Source Code Will Be Found Under ```SKSE/PluginSrc``` Directory
    - The Scripts Source Code Will Be Found Under ```Source/Scripts``` Directory

The idea and scope of this mod will be to cover as many weather/elemental effects as possible in a low script latenecy and dll running fashion to increase performance of event polling and effect applications.

### Current Mod Ideas
- Add All Sorts of effects for puddles
  - dynamic placement of puddles dependant on weather conditions
  - dynamic puddle stream runoffs dependant on water level and terrain slope
  - dynamic freezing of puddles when hit with ice magic, dragon ice attacks, and in cold weather
  - dynamic sublimation when hit with fire magic and dragon fire attacks
- Add Effects For Drier, Arid Climates and Weathers
  - dynamic water level drop(wells, puddles, etc)
  - flammable wood rating based on climate conditions and rating chance for catching on fire by
    torch, fire magic, or dragon fire attacks
  - increased thirst rating when used alongside Needs mods and A dynamic version when used only with this mod
    - The increased thirst rating would be some sort of summation or multiplier to Needs mods thirst system 
      while being a base rating plus a multiplier to the base rating for a standalone version

### Current Mod Progress

#### MCM Configuration
Main Page

![Alt text](Resources/README_Photos/MCM_Main.png?raw=true "Main Page")

Settings Page 

![Alt text](Resources/README_Photos/MCM_Settings.png?raw=true "Settings Page")