#!/bin/bash
# =============================================
#
#  Antenna measurements automation script
#  Optional arguments: INTERVAL_TILT_ANGLE START_TILT_ANGLE END_TILT_ANGLE
#
#  Written by Robin Janssens (robin@robinjanssens.net)
#
# =============================================

# ------------------------------
# Config values
# ------------------------------
SERIAL="30B1FBC"
RESULT_DIR="/Users/robin/Documents/BAP/results/"
FREQUENCY="868M"
SAMPLE_RATE="100k"
AMOUNT_OF_SAMPLES="500k"  # 500kSa / 100kSa/s = 5s
INTERVAL_TILT_ANGLE=${1:-"3"}  # first  argument or default:   3
START_TILT_ANGLE=${2:-"-30"}   # second argument or default: -30
END_TILT_ANGLE=${3:-"30"}      # third  argument or default:  30

# ------------------------------
# Move everything in the right position to start
# ------------------------------
echo Moving to start position at $START_TILT_ANGLE degrees
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan 0"
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt ${START_TILT_ANGLE}"
sleep 3

# ------------------------------
# Start measurement cycles
# ------------------------------
for i in `seq $START_TILT_ANGLE $INTERVAL_TILT_ANGLE $END_TILT_ANGLE`;
do
  FILENAME=${RESULT_DIR}result${i}
  echo Moving to $i degrees
  ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt $i"
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
matlab -r "visualize(\"$RESULT_DIR\",$START_TILT_ANGLE,$INTERVAL_TILT_ANGLE,$END_TILT_ANGLE)"
