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
SERIAL1="30CD3F9"
SERIAL2="30C62B2"
RESULT_DIR="/Users/robin/Documents/BAP/results/"
FREQUENCY="862.8M"
SAMPLE_RATE="1M"
AMOUNT_OF_SAMPLES="10M"    # 10MSa / 1MSa/s = 10s
INTERVAL_PAN_ANGLE=${1:-"30"}  # first  argument or default:  30
START_PAN_ANGLE=${2:-"-90"}    # second argument or default: -90
END_PAN_ANGLE=${3:-"90"}       # third  argument or default:  90

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
mkdir "${RESULT_DIR}array2"
for i in `seq $START_PAN_ANGLE $INTERVAL_PAN_ANGLE $END_PAN_ANGLE`;
do
  mkdir "${RESULT_DIR}array2/angle${i}"
  FILENAME1="${RESULT_DIR}array2/angle${i}/antenna0"
  FILENAME2="${RESULT_DIR}array2/angle${i}/antenna1"
  echo Moving to $i degrees
  ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan $i"
  sleep 2  # wait till the right position is reached
  # echo Get ready to transmit signal
  # read -p "Press enter to continue"
  echo Measuring at $i degrees
  uhd_rx_cfile -a "serial=${SERIAL1}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0,1 -A RX2,RX2 "${FILENAME1}" -g 40 &
  uhd_rx_cfile -a "serial=${SERIAL2}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0,1 -A RX2,RX2 "${FILENAME2}" -g 40
  # sleep 5
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
matlab -r "visualize_4ch(\"$RESULT_DIR\",$START_PAN_ANGLE,$INTERVAL_PAN_ANGLE,$END_PAN_ANGLE)"
