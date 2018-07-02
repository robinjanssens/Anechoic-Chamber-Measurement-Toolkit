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
SERIAL1="30C62B2"
SERIAL2="30CD3F9"
RESULT_DIR="/Users/robin/Documents/BAP/results/"
EXPERIMENT_DIR="meting_dennis_single/"
FREQUENCY="862.8M"
SAMPLE_RATE="1M"
AMOUNT_OF_SAMPLES="50M"  # 50MSa / 1MSa/s = 50s
INTERVAL_PAN_ANGLE=${1:-"30"}   # first  argument or default:   30
START_PAN_ANGLE=${2:-"-30"}     # second argument or default:  -30
END_PAN_ANGLE=${3:-"30"}        # third  argument or default:   30
INTERVAL_TILT_ANGLE=${4:-"30"}  # fourth  argument or default:  30
START_TILT_ANGLE=${5:-"-30"}    # fifth argument or default:   -30
END_TILT_ANGLE=${6:-"30"}       # sixth  argument or default:   30

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
mkdir "${RESULT_DIR}${EXPERIMENT_DIR}"
FILENAME1="${RESULT_DIR}${EXPERIMENT_DIR}antenna0"
FILENAME2="${RESULT_DIR}${EXPERIMENT_DIR}antenna1"
uhd_rx_cfile -a "serial=${SERIAL1}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0,1 -A RX2,RX2 "${FILENAME1}" -g 0 &
uhd_rx_cfile -a "serial=${SERIAL2}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0,1 -A RX2,RX2 "${FILENAME2}" -g 0 &
sleep 6
for i in `seq $START_PAN_ANGLE $INTERVAL_PAN_ANGLE $END_PAN_ANGLE`;
do
  echo Panning to $i degrees
  ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan $i"
  for j in `seq $START_TILT_ANGLE $INTERVAL_TILT_ANGLE $END_TILT_ANGLE`;
  do
    echo Tilting to $j degrees
    ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt $j"
    sleep 1  # wait till the right position is reached
    echo Measuring at $i degrees pan and $j degrees tilt
    read -p "After measurement press enter to continue to next angle"
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
# Run data processing and visualization
# ------------------------------
# echo Running data processing and visualization
# matlab -r "visualize(\"$RESULT_DIR\",$START_ANGLE,$INTERVAL_ANGLE,$END_ANGLE)"
