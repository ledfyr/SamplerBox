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
  #aconnect 'E-MU XMidi1X1:0' 'E-MU XMidi1X1:0'
fi
if [ -n "$emu" ] && [ -n "$irig" ]; then
  aconnect 'iRig Keys:0' 'E-MU XMidi1X1:0'
fi

# Use USB sound card if available
card1=`aplay -l | grep card | grep 'USB Audio Device' | sed 's/\],.*//' | head -1`
card1name=`echo $card1 | sed 's/.*\[//'`
card1no=`echo $card1 | awk '{print $2}' | sed 's/://'`
#echo "card1: <$card1> <$card1name> <$card1no>"

card2=`aplay -l | grep card | grep 'USB PnP Sound Device' | sed 's/\],.*//' | head -1`
card2name=`echo $card2 | sed 's/.*\[//'`
card2no=`echo $card2 | awk '{print $2}' | sed 's/://'`
#echo "card2: <$card2> <$card2name> <$card2no>"

cardname='no__card'
# Set max volume => card number ($card): aplay -l, device name (Speaker): amixer -c<cardno>
if [ -n "$card1name" ]; then
  cardname="$card1name"
  if [ -n "$card1no" ]; then
    amixer -c$card1no set Speaker 100%
  fi
fi
if [ -n "$card2name" ]; then
  cardname="$card2name"
  if [ -n "$card2no" ]; then
    amixer -c$card2no set Speaker 100%
  fi
fi

if [ -n "$card1name" ] && [ -n "$card2name" ]; then
  cardname="$card1name,$card2name"
fi

if [ -z "$card1name" ] && [ -z "$card2name" ]; then
  amixer set PCM 100%
fi

sampledir="/home/pi/sounds"
cd /home/pi/SamplerBox

#echo "$cardname"

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

