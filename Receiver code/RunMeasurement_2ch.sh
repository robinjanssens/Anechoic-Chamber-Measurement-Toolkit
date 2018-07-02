#!/bin/bash
# =============================================
#
#  Antenna measurements automation script
#  Optional arguments: INTERVAL_PAN_ANGLE START_PAN_ANGLE END_PAN_ANGLE
#
#  Written by Robin Janssens (robin@robinjanssens.net)
#
# =============================================

# ------------------------------
# Config values
# ------------------------------
SERIAL="30C62C6"
RESULT_DIR="/Users/robin/Documents/BAP/results/"
FREQUENCY="868M"
SAMPLE_RATE="100k"
AMOUNT_OF_SAMPLES="300k"  # 300kSa / 100kSa/s = 3s
INTERVAL_PAN_ANGLE=${1:-"15"}  # first  argument or default: 15
START_PAN_ANGLE=${2:-"-90"}   # second argument or default: -90
END_PAN_ANGLE=${3:-"90"}      # third  argument or default:  90

# ------------------------------
# Move everything in the right position to start
# ------------------------------
echo Moving to start position at $START_PAN_ANGLE degrees
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan ${START_PAN_ANGLE}"
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt 0"
sleep 5

# ------------------------------
# Start measurement cycles
# ------------------------------
for i in `seq $START_PAN_ANGLE $INTERVAL_PAN_ANGLE $END_PAN_ANGLE`;
do
  FILENAME=${RESULT_DIR}result${i}
  echo Moving to $i degrees
  ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan $i"
  sleep 2  # wait till the right position is reached
  echo Measuring at $i degrees
  uhd_rx_cfile -a "serial=${SERIAL}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0,1 -A RX2,RX2 "${FILENAME}" -g 40
done

# ------------------------------
# Move everything back to it's default position
# ------------------------------
echo Moving back to center position
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan 0"
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt 0"
sleep 5

# ------------------------------
# Run data processing and visualization
# ------------------------------
echo Running data processing and visualization
matlab -r "visualize_2ch(\"$RESULT_DIR\",$START_PAN_ANGLE,$INTERVAL_PAN_ANGLE,$END_PAN_ANGLE)"
