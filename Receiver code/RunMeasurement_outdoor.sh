#!/bin/bash
# =============================================
#
#  Antenna measurements automation script
#  Optional arguments: /
#
#  Written by Robin Janssens (robin@robinjanssens.net)
#
# =============================================

# ------------------------------
# Config values
# ------------------------------
SERIAL1="30C62C6"
SERIAL2="30C62B2"
RESULT_DIR="/Users/robin/Documents/BAP/results/"
FREQUENCY="862.8M"
SAMPLE_RATE="1M"
AMOUNT_OF_SAMPLES="30M"    # 20MSa / 1MSa/s = 20s

# ------------------------------
# Start measurement cycles
# ------------------------------
for i in `seq 1 1 100`;
do
  mkdir "${RESULT_DIR}outdoor_measurement/measurement${i}"
  FILENAME1="${RESULT_DIR}outdoor_measurement/measurement${i}/antenna0"
  FILENAME2="${RESULT_DIR}outdoor_measurement/measurement${i}/antenna1"
  uhd_rx_cfile -a "serial=${SERIAL1}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0,1 -A RX2,RX2 "${FILENAME1}" -g 30 &
  uhd_rx_cfile -a "serial=${SERIAL2}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0,1 -A RX2,RX2 "${FILENAME2}" -g 30
  read -p "Press enter to continue"
done
