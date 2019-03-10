SamplerBox
==========

Modified version of SamplerBox. Added features:
* Forked from velocity sensitivity patch by paul-at, so supports `%%velocitysensitivity` in definition.txt.
* Added possibility to control the max volume of individual samples (velocity works at the same time, but you now get a maximum level control for each sample). Use `%samplegain` in definition.txt
* Added possibility to stack two samples on top of each other. Use `%doublenote` in definition.txt to connect one sample to another. Both samples will be played when the first is played. Value 0 is necessary when only one sample is desired.
* Added kick directory (shared between all sample dirs, can have it's own definition.txt, kicks always load to midi note 2, doublenote from sampledir to kick works to stack samples with kick).
* Program change value < 64 changes kick, value >= 64 changes sample preset (64 = preset 0, 65 = preset 1 and so on).
* Added pitch bend for midi note 2 (kick). Pitch wheel and CC 2 control the pitch of the sample at note 2 and all other samples having note 2 as `%doublenote`.
* Command line parameters added, example on how to start: `python samplerbox.py "$cardname" "$sampledir" "$polyphony" "$midich" "$samplepreset"`
* Added support for two sound cards (kick plays only on card2, other samples plays on card1), specify the names separated by comma in the cardname command line parameter. Example: "card1,card2". It's still possible to use only one card by only supplying one card name in the command line parameter, then all samples (kick + others) are played on that single card.
* Some personal tweaks: samplebox-normal.py has no support for `%doublenote` and has the usual note-off behavior (suitable for piano), samplerbox.py has support for `%doublenote` and kills notes when playing sample #1 (suitable for drum samples).
* Auto-start: copy startm.sh to /home/pi, modify to fit your needs and add the following to /etc/rc.local (put on the row above "exit 0"): `/home/pi/startm.sh &`

Examples:

```
definition.txt:

%midinote_*_%samplegaind%doublenote.wav
%%velocitysensitivity=1


file names:

2_bd-rio_84d0.wav         (lone bass drum)
3_bd-rio_84d12.wav        (same bass drum as above + sample #12 playing at the same time)
...
12_clp-offshore_100d0.wav (clap)
...
56_sd-uplifter_100d0.wav  (snare)
```


Old README below:


An open-source audio sampler project based on RaspberryPi.

Website: www.samplerbox.org

[Install](#install)
----

You need a RaspberryPi and a DAC (such as [this 6€ one](http://www.ebay.fr/itm/1Pc-PCM2704-5V-Mini-USB-Alimente-Sound-Carte-DAC-decodeur-Board-pr-ordinateur-PC-/231334667385?pt=LH_DefaultDomain_71&hash=item35dc9ee479) that provides really high-quality sound – please note that without any DAC, the RaspberryPi's built-in soundcard would produce bad sound quality and lag).

1. Install the required dependencies (Python-related packages and audio libraries):

  ~~~
  sudo apt-get update ; sudo apt-get -y install python-dev python-numpy cython python-smbus portaudio19-dev
  git clone https://github.com/superquadratic/rtmidi-python.git ; cd rtmidi-python ; sudo python setup.py install ; cd .. 
  git clone http://people.csail.mit.edu/hubert/git/pyaudio.git ; cd pyaudio ; sudo python setup.py install ; cd ..
  ~~~

2. Download SamplerBox and build it with: 

  ~~~
  git clone https://github.com/josephernest/SamplerBox.git ;
  cd SamplerBox ; make 
  ~~~

3. Run the soft with `python samplerbox.py`.

4. Play some notes on the connected MIDI keyboard, you'll hear some sound!  

*(Optional)*  Modify `samplerbox.py`'s first lines if you want to change root directory for sample-sets, default soundcard, etc.

<!--  *Note:* Don't install `pyaudio` with `apt-get install python-pyaudio` since this would install version 0.2.4, that wouldn't work for this project. Version 0.2.8 or higher is required. -->

[How to use it](#howto)
----

See the [FAQ](http://www.samplerbox.org/faq) on www.samplerbox.org.


[About](#about)
----

Author : Joseph Ernest (twitter: [@JosephErnest](http:/twitter.com/JosephErnest), mail: [contact@samplerbox.org](mailto:contact@samplerbox.org))


[License](#license)
----

[Creative Commons BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0/)
