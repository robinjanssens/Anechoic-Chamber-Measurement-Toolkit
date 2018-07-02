#!/bin/bash
# =============================================
#
#  Antenna measurements automation script
#  Optional arguments: INTERVAL_PAN_ANGLE START_PAN_ANGLE END_PAN_ANGLE INTERVAL_TILT_ANGLE START_TILT_ANGLE END_TILT_ANGLE
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
AMOUNT_OF_SAMPLES="100k"       # 100kSa / 100kSa/s = 1s
INTERVAL_PAN_ANGLE=${1:-"5"}   # first  argument or default:   5
START_PAN_ANGLE=${2:-"-90"}    # second argument or default: -90
END_PAN_ANGLE=${3:-"90"}       # third  argument or default:  90
INTERVAL_TILT_ANGLE=${4:-"3"}  # fourth  argument or default:   3
START_TILT_ANGLE=${5:-"-30"}   # fifth argument or default: -30
END_TILT_ANGLE=${6:-"30"}      # sixth  argument or default:  30

# ------------------------------
# Start time measurment
# ------------------------------
START_TIME=$(date +%s)

# ------------------------------
# Disable sleep on MacOS
# ------------------------------
# echo Starting caffeinate to prevent MacOS going to sleep
# caffeinate &
# CAFFEINATE_PID=$!
# echo Caffeinate running with PID $CAFFEINATE_PID

# ------------------------------
# Move everything in the right position to start
# ------------------------------
echo Moving to start position at $START_ANGLE degrees
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan ${START_PAN_ANGLE}"
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt ${START_TILT_ANGLE}"
sleep 3

# ------------------------------
# Start measurement cycles
# ------------------------------
for i in `seq $START_PAN_ANGLE $INTERVAL_PAN_ANGLE $END_PAN_ANGLE`;
do
  echo Panning to $i degrees
  ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan $i"
  for j in `seq $START_TILT_ANGLE $INTERVAL_TILT_ANGLE $END_TILT_ANGLE`;
  do
    echo Tilting to $j degrees
    ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt $j"
    FILENAME="${RESULT_DIR}result(${i})(${j})"
    # sleep 1  # wait till the right position is reached
    echo Measuring at $i degrees pan and $j degrees tilt
    uhd_rx_cfile -a "serial=${SERIAL}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0 -A RX2 "${FILENAME}" -g 40
  done
done

# ------------------------------
# Move everything back to it's default position
# ------------------------------
echo Moving back to center position
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan 0"
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt 0"
sleep 3

# ------------------------------
# Re-enable sleep on MacOS
# ------------------------------
# echo Killing caffeinate
# kill $CAFFEINATE_PID

# ------------------------------
# Calculate and print ellapsed time
# ------------------------------
END_TIME=$(date +%s)
DIFF_TIME=`expr $END_TIME - $START_TIME`
echo "Duration: ${DIFF_TIME} s"

# ------------------------------
# Run data processing and visualization
# ------------------------------
echo Running data processing and visualization
matlab -r "visualize_3D(\"$RESULT_DIR\",$START_PAN_ANGLE,$INTERVAL_PAN_ANGLE,$END_PAN_ANGLE,$START_TILT_ANGLE,$INTERVAL_TILT_ANGLE,$END_TILT_ANGLE)"
