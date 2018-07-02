# Antenna Measurements in Anechoic Chamber

## How To Run a Measurement

### Start Transmitter
- The transmitter code can be found in the folder `Transmitter code`
- Open `transmitter.grc` in Gnu Radio Companion
- Change frequency to the desired value
- Run application

### Start Receiver
#### Manual
- The receiver code can be found in the folder `Receiver code`
- Change the serial number of your device to the correct one in the desired shell file.
- Make sure the result directory exists.
- To start a measurement you can for example type `bash RunMeasurement_pan.sh` in the terminal to run a measurement with the default configuration from -90 to 90 degrees with an interval of 5 degrees.
- You can add optional arguments to alter the angles using the following syntax `bash RunMeasurement_pan.sh <INTERVAL_PAN_ANGLE> <START_PAN_ANGLE> <END_PAN_ANGLE>`
- After the measurement is completed MATLAB will process and visualize the results.

#### Automatic (experimental)
- The receiver code can be found in the folder `Receiver code`
- To start a measurement from the terminal type `bash cli_wizard.sh`

## Ideas for Improvements
- Make MATLAB code automatically detect angles in file names instead of giving it as an argument. This would allow for variable angle intervals.
- Improve the wizard with more regular expression checks.
- Find a way to start and stop the receiver without reloading the firmware. Probably by change the `uhd_rx_cfile` code. This is necessary to speed up the process. Especially for 3D pattern measurements this will be helpfull.
- Get the `uhd_siggen` command working to start and stop the transmitter automatically from code. I tried `uhd_siggen -a "serial=${SERIAL}" -f ${FREQUENCY} -s ${SAMPLE_RATE} -c 0 -A TX/RX -g 10 --sine` but failed to get it working.
- Find a way to send LoRa/Dash-7 packages without human intervention to automate AoA measurements.
- Automatically generate log files to save measurement parameters.
- Make gain configurable.
- Compensate for input gain in MATLAB code.
