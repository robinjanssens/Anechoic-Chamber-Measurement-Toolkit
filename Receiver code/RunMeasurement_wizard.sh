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
# Overwrite config values
# ------------------------------
# START_PAN_ANGLE="-90"   # -159 -> 159  degrees
# STOP_PAN_ANGLE="90"     # start -> 159 degrees
# INTERVAL_PAN_ANGLE="5"  #              degrees
# START_TILT_ANGLE="-30"  # -47 -> 31    degrees
# STOP_TILT_ANGLE="30"    # start -> 31  degrees
# INTERVAL_TILT_ANGLE="5" #              degrees
# AMOUNT_OF_USRPS="1"     # 1, 2 or 3
# FREQUENCY="868M"        # 70MHz -> 6GHz
# SAMPLE_RATE="100k"      # Sa/s
# MEASUREMENT_TIME="3"    # seconds
# RESULT_DIR="/Users/robin/Documents/BAP/results/"

# ------------------------------
# Default values
# ------------------------------
DEFAULT_START_PAN_ANGLE="-90"   # -159 -> 159  degrees
DEFAULT_STOP_PAN_ANGLE="90"     # start -> 159 degrees
DEFAULT_INTERVAL_PAN_ANGLE="5"  #              degrees
DEFAULT_START_TILT_ANGLE="-30"  # -47 -> 31    degrees
DEFAULT_STOP_TILT_ANGLE="30"    # start -> 31  degrees
DEFAULT_INTERVAL_TILT_ANGLE="5" #              degrees
DEFAULT_AMOUNT_OF_USRPS="1"     # 1, 2 or 3
DEFAULT_FREQUENCY="868M"        # 70MHz -> 6GHz
DEFAULT_SAMPLE_RATE="100k"      # Sa/s
DEFAULT_MEASUREMENT_TIME="3"    # seconds
DEFAULT_RESULT_DIR="/Users/robin/Documents/BAP/results/"

# ------------------------------
# Wizard functions
# ------------------------------
function choose_pan {
  while [[ -z ${START_PAN_ANGLE+x} ]]; do
    read -p "Start pan angle (-159 -> 159): " START_PAN_ANGLE
    if [ "$START_PAN_ANGLE" == "" ]; then
      START_PAN_ANGLE=$DEFAULT_START_PAN_ANGLE
      echo Default start pan angle selected of $START_PAN_ANGLE degrees
    fi
    if [[ $START_PAN_ANGLE -lt -159 || $START_PAN_ANGLE -gt 159 ]]; then
      echo \"$START_PAN_ANGLE\" degrees is not a valid start pan angle
      unset START_PAN_ANGLE
    fi
  done
  while [[ -z ${STOP_PAN_ANGLE+x} ]]; do
    read -p "Stop pan angle ($START_PAN_ANGLE -> 159): " STOP_PAN_ANGLE
    if [ "$STOP_PAN_ANGLE" == "" ]; then
      STOP_PAN_ANGLE=$DEFAULT_STOP_PAN_ANGLE
      echo Default stop pan angle selected of $STOP_PAN_ANGLE degrees
    fi
    if [[ $STOP_PAN_ANGLE -lt $START_PAN_ANGLE || $STOP_PAN_ANGLE -gt 159 ]]; then
      echo \"$STOP_PAN_ANGLE\" degrees is not a valid stop pan angle
      unset STOP_PAN_ANGLE
    fi
  done
  while [[ -z ${INTERVAL_PAN_ANGLE+x} ]]; do
    read -p "Interval pan angle: " INTERVAL_PAN_ANGLE
    if [ "$INTERVAL_PAN_ANGLE" == "" ]; then
      INTERVAL_PAN_ANGLE=$DEFAULT_INTERVAL_PAN_ANGLE
      echo Default interval pan angle selected of $INTERVAL_PAN_ANGLE degrees
    fi
    if [[ $INTERVAL_PAN_ANGLE -lt 0 ]]; then
      echo \"$INTERVAL_PAN_ANGLE\" degrees is not a valid interval pan angle
      unset INTERVAL_PAN_ANGLE
    fi
  done
}
function choose_tilt {
  while [[ -z ${START_TILT_ANGLE+x} ]]; do
    read -p "Start tilt angle (-47 -> 31): " START_TILT_ANGLE
    if [ "$START_TILT_ANGLE" == "" ]; then
      START_TILT_ANGLE=$DEFAULT_START_TILT_ANGLE
      echo Default start tilt angle selected of $START_TILT_ANGLE degrees
    fi
    if [[ $START_TILT_ANGLE -lt -47 || $START_TILT_ANGLE -gt 31 ]]; then
      echo \"$START_TILT_ANGLE\" degrees is not a valid start tilt angle
      unset START_TILT_ANGLE
    fi
  done
  while [[ -z ${STOP_TILT_ANGLE+x} ]]; do
    read -p "Stop tilt angle ($START_TILT_ANGLE -> 31): " STOP_TILT_ANGLE
    if [ "$STOP_TILT_ANGLE" == "" ]; then
      STOP_TILT_ANGLE=$DEFAULT_STOP_TILT_ANGLE
      echo Default stop tilt angle selected of $STOP_TILT_ANGLE degrees
    fi
    if [[ $STOP_TILT_ANGLE -lt $START_TILT_ANGLE || $STOP_TILT_ANGLE -gt 31 ]]; then
      echo \"$STOP_TILT_ANGLE\" degrees is not a valid stop tilt angle
      unset STOP_TILT_ANGLE
    fi
  done
  while [[ -z ${INTERVAL_TILT_ANGLE+x} ]]; do
    read -p "Interval tilt angle: " INTERVAL_TILT_ANGLE
    if [ "$INTERVAL_TILT_ANGLE" == "" ]; then
      INTERVAL_TILT_ANGLE=$DEFAULT_INTERVAL_TILT_ANGLE
      echo Default interval tilt angle selected of $INTERVAL_TILT_ANGLE degrees
    fi
    if [[ $INTERVAL_TILT_ANGLE -lt 0 ]]; then
      echo \"$INTERVAL_TILT_ANGLE\" degrees is not a valid interval tilt angle
      unset INTERVAL_TILT_ANGLE
    fi
  done
}
function empty_pan {
  START_PAN_ANGLE=0
  STOP_PAN_ANGLE=0
  INTERVAL_PAN_ANGLE=1
}
function empty_tilt {
  START_TILT_ANGLE=0
  STOP_TILT_ANGLE=0
  INTERVAL_TILT_ANGLE=1
}
function choose_amount_of_usrps {
  while [[ -z ${AMOUNT_OF_USRPS+x} ]]; do
    read -p "Amount of USRP's (0, 1 or 2): " AMOUNT_OF_USRPS
    if [ "$AMOUNT_OF_USRPS" == "" ]; then
      AMOUNT_OF_USRPS=$DEFAULT_AMOUNT_OF_USRPS
      echo Default amount of USRP\'s selected of $AMOUNT_OF_USRPS
    fi
    if [[ $AMOUNT_OF_USRPS -eq 0 || $AMOUNT_OF_USRPS -eq 1 || $AMOUNT_OF_USRPS -eq 2 ]]; then
      : # do nothing
    else
      echo \"$AMOUNT_OF_USRPS\" is not a supported amount of USRP\'s
      unset AMOUNT_OF_USRPS
    fi
  done
}
function choose_serial {
  if [[ $AMOUNT_OF_USRPS -ge 1 ]]; then
    while [[ -z ${SERIAL1+x} ]]; do
      uhd_find_devices
      read -p "Serial of receiver USRP: " SERIAL1
      if [[ ${#SERIAL1} -ne 7 ]]; then
        echo \"$SERIAL1\" is not a valid serial
        unset SERIAL1
      fi
    done
  fi
  # echo Receiver USRP serial is $SERIAL1
  if [[ $AMOUNT_OF_USRPS -ge 2 ]]; then
    while [[ -z ${SERIAL2+x} ]]; do
      uhd_find_devices
      read -p "Serial of receiver USRP: " SERIAL2
      if [[ ${#SERIAL2} -ne 7 ]]; then
        echo \"$SERIAL2\" is not a valid serial
        unset SERIAL2
      fi
    done
  fi
  # echo Receiver USRP serial is $SERIAL2
}
function choose_frequency {
  while [[ -z ${FREQUENCY+x} ]]; do
    read -p "Frequency (70MHz -> 6GHz): " FREQUENCY
    if [ "$FREQUENCY" == "" ]; then
      FREQUENCY=$DEFAULT_FREQUENCY
      echo Default frequency selected of ${FREQUENCY}Hz
    fi
    FREQUENCY="${FREQUENCY/Hz/}"
    FREQUENCY="${FREQUENCY/k/000}"
    FREQUENCY="${FREQUENCY/M/000000}"
    FREQUENCY="${FREQUENCY/G/000000000}"
    if [[ $FREQUENCY -lt 70000000 || $FREQUENCY -gt 6000000000 ]]; then
      echo \"${FREQUENCY}Hz\" is not a valid frequency
      unset FREQUENCY
    fi
  done
}
function choose_sample_rate_and_amount {
  while [[ -z ${SAMPLE_RATE+x} ]]; do
    read -p "Sample rate (Sa/s): " SAMPLE_RATE
    if [ "$SAMPLE_RATE" == "" ]; then
      SAMPLE_RATE=$DEFAULT_SAMPLE_RATE
      echo Default sample rate selected of ${SAMPLE_RATE}Sa\/s
    fi
    SAMPLE_RATE="${SAMPLE_RATE/Sa/}"
    SAMPLE_RATE="${SAMPLE_RATE/\//}"
    SAMPLE_RATE="${SAMPLE_RATE/s/}"
    SAMPLE_RATE="${SAMPLE_RATE/k/000}"
    SAMPLE_RATE="${SAMPLE_RATE/M/000000}"
    SAMPLE_RATE="${SAMPLE_RATE/G/000000000}"
    if ! [[ $SAMPLE_RATE =~ ^[0-9]+([.][0-9]+)?$ ]]; then  # check if it is a valid positive number
      echo \"${SAMPLE_RATE}Sa\/s\" is not a valid sample rate
      unset SAMPLE_RATE
    fi
  done
  while [[ -z ${MEASUREMENT_TIME+x} ]]; do
    read -p "Measurement time (seconds): " MEASUREMENT_TIME
    if [ "$MEASUREMENT_TIME" == "" ]; then
      MEASUREMENT_TIME=$DEFAULT_MEASUREMENT_TIME
      echo Default measurement time selected of ${MEASUREMENT_TIME}s
    fi
    MEASUREMENT_TIME="${MEASUREMENT_TIME/s/}"
    if ! [[ $MEASUREMENT_TIME =~ ^[0-9]+([.][0-9]+)?$ ]]; then  # check if it is a valid positive number
      echo \"${MEASUREMENT_TIME}s\" is not a valid measurement time
      unset MEASUREMENT_TIME
    fi
  done
  AMOUNT_OF_SAMPLES=$((${SAMPLE_RATE} * ${MEASUREMENT_TIME}))
}
function choose_result_dir {
  while [[ -z ${RESULT_DIR+x} ]]; do
    read -p "Result directory path: " RESULT_DIR
    if [ "$RESULT_DIR" == "" ]; then
      RESULT_DIR=$DEFAULT_RESULT_DIR
      echo Default result directory selected of ${RESULT_DIR}
    fi
    if [ ! -d "$RESULT_DIR" ]; then
      mkdir RESULT_DIR
    fi
  done
}

# ------------------------------
# Wizard
# ------------------------------
while [[ -z ${MODE+x} ]]; do
  echo 'Available modes: pan, tilt, 2dof, test, quit'
  read -p 'Select mode: ' MODE
  case "$MODE" in

    # ----------------------------------------
    # Pan Config
    # ----------------------------------------
    p|pan  )
      choose_pan
      empty_tilt
      choose_amount_of_usrps
      choose_serial
      choose_frequency
      choose_sample_rate_and_amount
      choose_result_dir
    ;;

    # ----------------------------------------
    # Tilt Config
    # ----------------------------------------
    t|tilt )
      choose_tilt
      empty_pan
      choose_amount_of_usrps
      choose_serial
      choose_frequency
      choose_sample_rate_and_amount
      choose_result_dir
    ;;

    # ----------------------------------------
    # 2DOF Config
    # ----------------------------------------
    2|2dof )
      choose_pan
      choose_tilt
      choose_amount_of_usrps
      choose_serial
      choose_frequency
      choose_sample_rate_and_amount
      choose_result_dir
    ;;

    # ----------------------------------------
    # Test Config
    # ----------------------------------------
    test )
      choose_pan
      choose_tilt
      echo test
    ;;

    # ----------------------------------------
    # Quit
    # ----------------------------------------
    q|quit )
      echo Quitting application
      exit
    ;;

    # ----------------------------------------
    # Default Catch
    # ----------------------------------------
    *      )
      echo \"$MODE\" is not a valid mode
      unset MODE
    ;;

  esac
done
echo The chosen mode is "$MODE"

# ------------------------------
# Start time measurement
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
echo Moving to start position at $START_PAN_ANGLE degrees pan and $START_TILT_ANGLE degrees tilt
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan ${START_PAN_ANGLE}"
ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt ${START_TILT_ANGLE}"
sleep 3

# ------------------------------
# Start measurement cycles
# ------------------------------
for i in `seq $START_PAN_ANGLE $INTERVAL_PAN_ANGLE $STOP_PAN_ANGLE`;
do
  echo Panning to $i degrees
  ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.pan $i"
  for j in `seq $START_TILT_ANGLE $INTERVAL_TILT_ANGLE $STOP_TILT_ANGLE`;
  do
    echo Tilting to $j degrees
    ruby -r "./FLIR-Pan-Tilt-Ruby-Library/PanTilt.rb" -e "PanTilt.tilt $j"
    FILENAME="${RESULT_DIR}result(${i})(${j})"
    # sleep 1  # wait till the right position is reached
    if [[ -z ${SERIAL1+x} ]]; then
      echo Dummy measurement at $i degrees pan and $j degrees tilt
    else
      echo Measuring at $i degrees pan and $j degrees tilt
      if [[ -z ${SERIAL2+x} ]]; then
        : # do nothing
      else
        uhd_rx_cfile -a "serial=${SERIAL2}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0 -A RX2 "${FILENAME}" -g 30 &
      fi
      uhd_rx_cfile -a "serial=${SERIAL1}" -f ${FREQUENCY} -r ${SAMPLE_RATE} -N ${AMOUNT_OF_SAMPLES} -c 0 -A RX2 "${FILENAME}" -g 30
    fi
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
echo "Measurement duration: ${DIFF_TIME} s"
