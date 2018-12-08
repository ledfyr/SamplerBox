#!/bin/bash

# Connect MIDI devices
while true; do
  emu=`aconnect -l | grep 'E-MU XMidi1X1'`
  irig=`aconnect -l | grep 'iRig Keys'`
  if [ -n "$emu" ] || [ -n "$irig" ]; then
    break
  fi
  sleep 5s
done

if [ -n "$irig" ]; then
  aconnect 'iRig Keys:0' 'Midi Through:0'
fi
if [ -n "$emu" ]; then
  aconnect 'E-MU XMidi1X1:0' 'Midi Through:0'
fi
if [ -n "$emu" ] && [ -n "$irig" ]; then
  aconnect 'iRig Keys:0' 'E-MU XMidi1X1:0'
fi

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


sampledir="/home/pi/sounds"
cd /home/pi/velo-SamplerBox

#connected=`lsblk | grep sda` # Select piano or drum machine mode depending on if a card reader is connected
#if [ -n "$connected" ]; then
#  # Piano mode
#  midich="1"
#  polyphony="10"
#  samplepreset="0"
#  python samplerbox_normal.py "$cardname" "$sampledir" "$polyphony" "$midich" "$samplepreset" &
#else

# Drum machine mode
midich="4"
polyphony="3"
samplepreset="1"
python samplerbox.py "$cardname" "$sampledir" "$polyphony" "$midich" "$samplepreset" &

#fi

