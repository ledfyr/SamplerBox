#!/bin/bash

# Start MIDIcloro
cd /home/pi
i="0"
while [ $i -lt 4 ]; do
  emu=`aconnect -l | grep 'E-MU XMidi1X1'`
  #if ! ps aux | grep -v 'grep' | grep -v 'startm' | grep 'midicloro' ; then
  if [ -n "$emu" ]; then
    block=`lsblk | grep sda` # Block start of midicloro if USB card reader is connected
    if [ -z "$block" ]; then
      ./midicloro &
      aconnect 'Midi Through:0' 'E-MU XMidi1X1:0'
    else
      i="4"
    fi
    break;
  fi
  sleep 5s
  i=$[$i+1]
done


# Use USB sound card if available
card=`aplay -l | grep card | grep -v bcm2835 | sed 's/\],.*//' | head -1`
cardname=`echo $card | sed 's/.*\[//'`
cardno=`echo $card | awk '{print $2}' | sed 's/://'`
if [ -n "$cardname" ]; then
  # Card number ($card): aplay -l, Device name (Speaker): amixer -c<cardno>
  if [ -n "$cardno" ]; then
    amixer -c$cardno set Speaker 100%
  fi
else
  amixer set PCM 100%
  cardname='no__card'
fi


sampledir="/home/pi/samples"
cd /home/pi/velo-SamplerBox

if [ $i -gt 3 ]; then
  # midicloro was not started - connect MIDI devices directly to samplerbox input port
  if [ -n "$emu" ]; then
    aconnect 'E-MU XMidi1X1:0' 'Midi Through:0'
  fi
  irig=`aconnect -l | grep 'iRig Keys'`
  if [ -n "$irig" ]; then
    aconnect 'iRig Keys:0' 'Midi Through:0'
  fi
  midich="1"
  polyphony="10"
  samplepreset="0"
  python samplerbox_normal.py "$cardname" "$sampledir" "$polyphony" "$midich" "$samplepreset" &
else
  # midicloro was started
  midich="4"
  polyphony="3"
  samplepreset="1"
  python samplerbox.py "$cardname" "$sampledir" "$polyphony" "$midich" "$samplepreset" &
fi

