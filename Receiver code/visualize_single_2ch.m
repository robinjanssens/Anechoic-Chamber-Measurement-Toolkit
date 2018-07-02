% =============================================
%
%  Function to visualize raw data from antenna measurements
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================

result_dir = '/Users/robin/Documents/BAP/results/';
result_file = 'double1';

% ------------------------------
% Data Processing
% ------------------------------
filename = strcat(result_dir,result_file,'.0');
raw_data = read_complex_binary(filename);
receive_power1 = (raw_data'*raw_data)/length(raw_data)
receiver_power1_dbm = 10*log10(max(receive_power1)*1000)

filename = strcat(result_dir,result_file,'.1');
raw_data = read_complex_binary(filename);
receive_power2 = (raw_data'*raw_data)/length(raw_data)
receiver_power2_dbm = 10*log10(max(receive_power2)*1000)
