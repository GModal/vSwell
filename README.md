<!---
Markdown
-->

## vSwell

*vSwell* is a volume envelope audio effect plugin. The effect can be triggered by an audio signal, external control or a MIDI notein.

The plugin is provided in two versions:

   * vSwell 
      * Mono, with a separate trigger input
   * vSwellST
      * Stereo, with selectable trigger channels

Plugins are provided in LV2, VST, VST3 and CLAP formats, compiled for Linux environments. With a working hvcc environment, the patch *should* compile for other systems.

### Mono vs. Stereo

On the mono version the effect signal input is separate from the trigger signal input. This is *mostly* so alternative signal dynamics can act as a trigger (a fuzz can run through the effect, but the unboosted "clean" signal can be the trigger). However, other unrelated sounds can serve as the trigger, also.

The stereo version can select either channel (or both, or neither) as the trigger, and both channels have the envelope applied.

The mono version doesn't always work well with DAWs or other track-oriented applications. Two inputs and one output is more difficult to integrate into an automatic interface.

### Parameters

   * Attack Level
      * Signal level target value for the Attack envelope
   * Attack ms
      * Length of Attack portion of env, in milliseconds
   * Mid Level
      * Signal level target value for the Middle envelope
   * Mid ms
      * Length of the Middle portion of env, in milliseconds
   * Release ms
      * Length of Release, in milliseconds
   * Shape
      * The shape of the envelope
         * 1.0 is linear
         * less than 1.0 is convex
         * greater than 1.0 is concave
   * SubEnv Level
      * The mimimum "floor" signal level, "sub" or below the envelope
   * Threshold High
      * The effect triggers above this RMS db level
   * Threshold Low
      * db level BELOW the High Threshold where the effect resets for a new trigger
      * REPEAT: this value is *subtracted* from the Threshold High for the low threshold
   * Threshold Strict
      * vSwell has some triggering enhancements, and selecting this turns them OFF. The trigger inputs in "strict" mode will more closely follow the RMS value of the *Threshold High* setting.
   * Trigger Delay
      * Delay before an envelope begins, after a trigger event. A longer delay can reduce artifacts at the start of an envelope
   * Trigger EXT
      * An external trigger parameter, like a CV

#### vSwell only

   * Trigger by audio ON (Mono only)
      * If ON, the audio trigger is active. Turn this off if only an external or MIDI trigger is needed

#### vSwellST only

   * Trigger Left (Stereo only)
      * If ON, the audio trigger is active on the Left channel
      * Turn BOTH left and right off for external trigger only.
   * Trigger Right (Stereo only)
      * If ON, the audio trigger is active on the Right channel
      * Turn BOTH left and right off for external trigger only.

### Envelope Terminology

vSwell uses the terms outlined on the graphic below for envelopes. The choice of terms is largely dictated by the Heavy (hvcc) compiler, as it only organizes parameters alphabetically. While relatively self-explanatory, here's a visual guide:

![Shape param](extra/envdefs2.png)

### Inputs/Output

   * **Audio Input 1** : Audio Effect input
   * **Audio Input 2** : Audio Trigger input
   * **events-in** : MIDI Trigger input
   * **Audio Output 1** : Audio Output (mono)

(Port naming differs for different plugin formats. Above is the LV2 schema.)

### Tips

   * ANY MIDI noteon (with non-zero velocity) sent to the MIDI input port will trigger the envelope.

   * Release fades to the SubEnvelope level.

   * Higher settings for *Threshold High* raise the threshold, and make triggering less likely. Higher threshold == less sensitive. *Threshold Low* is the # of decibels **below** *Threshold High* at which the trigger resets. I.E., the signal must drop by this amount before a new trigger event can occur.

   * Setting the SubEnv Level above 0.1 and adjusting the envelope to slowly raise the level can create an effect similar to compression. It's not really compression *per se*, but it sounds cool (adding reverb also is cool).

   * The Shape parameter is exponential. When set to 1.0, the envelope curves are linear. Below 1.0, the curves are convex, above 1.0 they become concave (scooped):

![Shape param](extra/shape_param.png)

**Warning!** 

Setting **Attack Level** and **Mid Level** above 1.0 AND the **Shape** parameter above 1.0 can lead to VERY high levels. There is a very simple 'safety' built in -- the output shouldn't exceed 2.5X the input.


### About vSwell

vSwell is based on a Pure Data patch, and built with the Heavy (hvcc) Pd compiler and the DISTRHO Plugin Framework.

This plugin was inspired by Pierre Massat's cool 'GuitarExtended' blog, circa 2012, specifically the "Bold As Love" patch. However, that patch doesn't encorporate a **schmitt trigger**, some form of which is *de rigueur* for audio-triggered FX.

Unfortunately, the Heavy compiler doesn't include [threshold~], so I included a custom *schmitt trigger* abstraction.

The Pd source patch is also included, and the plugin should build for any other OS that supports the "modern" version of hvcc (modern being support for python3).

   * [Miller Puckette and Pure Data](http://msp.ucsd.edu/index.htm)
   * [hvcc, the 'Heavy' Pd compiler](https://github.com/Wasted-Audio/hvcc)
      * Qudos to [dromer](https://github.com/dromer) for updating the original EnzienAudio code to python3
   * [DPF - DISTRHO Plugin Framework](https://distrho.github.io/DPF/index.html)

No effort has been made to integrate a fancy GUI for the plugin.

vSwell was written by Doug Garmon, and released under the MIT licence.

### Installing the prebuilds

The Releases section has a zip file with pre-built Linux plugin binaries. There's currently no installer, so just move the associated plugins to your home **.lv2**, **.vst**, and **.clap** directories. And the .vst3 directory as well, although I've not tested the VST3 version.

The build version (Makefile) includes a simple installation script, for local (user home) use.

### Building vSwell

- Install the **heavy** compiler:
```
$ pip3 install hvcc
```
Instructions for installing hvcc directly (not with the python installer) can be found on the repository (the link can be found above).

Clone the vSwell source (and the DISTHRO Plugin Framework):

```
git clone -recursive https://github.com/GModal/vSwell
```

Open a terminal (or cd to) the ChaffVerb directory, then enter:

`make`

There's a simple install option for local (single user) install:

`make install`

The plugin folders for each type must be present for install to work. These are named **.lv2**, **.vst**, and **.clap**, in your home directory. Each plugin can be manually copied to the local directories as well.
