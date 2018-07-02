% =============================================
%
%  Function to visualize raw data from antenna measurements
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================
function visualize_4ch(result_dir,start_angle,interval_angle,end_angle)

  result_dir = [result_dir 'array2/'];

  % ------------------------------
  % Data Processing
  % ------------------------------
  receive_powers1 = [];
  angles = start_angle:interval_angle:end_angle;
  for angle = angles
      filename = strcat(result_dir,'angle',num2str(angle),'/antenna0','.0');
      raw_data = read_complex_binary(filename);
      receive_power = raw_data'*raw_data;
      receive_powers1 = [receive_powers1 receive_power];
  end

  receive_powers2 = [];
  angles = start_angle:interval_angle:end_angle;
  for angle = angles
      filename = strcat(result_dir,'angle',num2str(angle),'/antenna0','.1');
      raw_data = read_complex_binary(filename);
      receive_power = raw_data'*raw_data;
      receive_powers2 = [receive_powers2 receive_power];
  end

  receive_powers3 = [];
  angles = start_angle:interval_angle:end_angle;
  for angle = angles
      filename = strcat(result_dir,'angle',num2str(angle),'/antenna1','.0');
      raw_data = read_complex_binary(filename);
      receive_power = raw_data'*raw_data;
      receive_powers3 = [receive_powers3 receive_power];
  end

  receive_powers4 = [];
  angles = start_angle:interval_angle:end_angle;
  for angle = angles
      filename = strcat(result_dir,'angle',num2str(angle),'/antenna1','.1');
      raw_data = read_complex_binary(filename);
      receive_power = raw_data'*raw_data;
      receive_powers4 = [receive_powers4 receive_power];
  end

  % ------------------------------
  % Maximum power
  % ------------------------------
  ideal_angle1 = sum(angles.*(receive_powers1==max(receive_powers1)))
  maximum_power1_dbm = 10*log10(max(receive_powers1)*1000)
  center_power1_dbm = 10*log10(receive_powers1(round(length(receive_powers1)/2))*1000)

  ideal_angle2 = sum(angles.*(receive_powers2==max(receive_powers2)))
  maximum_power2_dbm = 20*log10(max(receive_powers2)*2000)
  center_power2_dbm = 20*log10(receive_powers2(round(length(receive_powers2)/2))*1000)

  difference_dbm = abs(maximum_power1_dbm-maximum_power2_dbm)

  % ------------------------------
  % Normalize values
  % ------------------------------
  receive_powers = receive_powers./max(receive_powers);
  receive_fields = receive_fields./max(receive_fields);

  % ------------------------------
  % Data vizualization
  % ------------------------------
  theta=angles*pi/180;
  polar(theta,receive_powers1,'-xred');
  hold on;
  polar(theta,receive_powers2,'-xyellow');
  hold on;
  polar(theta,receive_powers3,'-xgreen');
  hold on;
  polar(theta,receive_powers4,'-xblue');
  hold off;
%   hold on;
%   polardb(theta,receive_powers,0);
%   hold off;

end
