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
SERIAL="30CD3F9"
RESULT_DIR="/Users/robin/Documents/BAP/results/"
EXPERIMENT_DIR="sma/forth_vertical/"
FREQUENCY="868M"
SAMPLE_RATE="100k"
AMOUNT_OF_SAMPLES="100k"  # 100kSa / 100kSa/s = 1s
INTERVAL_PAN_ANGLE=${1:-"5"}  # first  argument or default:   5
START_PAN_ANGLE=${2:-"-90"}   # second argument or default: -90
END_PAN_ANGLE=${3:-"90"}      # third  argument or default:  90

# ------------------------------
# Move everything in the right position to start
# ------------------------------
echo Moving to start position at $START_PAN_ANGLE degrees
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan ${START_PAN_ANGLE}"
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt 0"
sleep 3

# ------------------------------
# Start measurement cycles
# ------------------------------
mkdir "${RESULT_DIR}${EXPERIMENT_DIR}"
for i in `seq $START_PAN_ANGLE $INTERVAL_PAN_ANGLE $END_PAN_ANGLE`;
do
  FILENAME=${RESULT_DIR}${EXPERIMENT_DIR}result${i}
  echo Moving to $i degrees
  ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan $i"
  # sleep 1  # wait till the right position is reached
  echo Measuring at $i degrees
  uhd_rx_cfile -a "serial=${SERIAL}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0 -A RX2 "${FILENAME}" -g 40
done

# ------------------------------
# Move everything back to it's default position
# ------------------------------
echo Moving back to center position
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan 0"
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt 0"
sleep 3

# ------------------------------
# Run data processing and visualization
# ------------------------------
echo Running data processing and visualization
matlab -r "visualize(\"${RESULT_DIR}${EXPERIMENT_DIR}\",$START_PAN_ANGLE,$INTERVAL_PAN_ANGLE,$END_PAN_ANGLE)"
