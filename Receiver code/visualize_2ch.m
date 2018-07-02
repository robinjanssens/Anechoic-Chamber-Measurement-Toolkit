% =============================================
%
%  Function to visualize raw data from antenna measurements
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================
function visualize(result_dir,start_angle,interval_angle,end_angle)

  % ------------------------------
  % Data Processing
  % ------------------------------
  receive_powers1 = [];
  receive_fields1 = [];
  angles = start_angle:interval_angle:end_angle;
  for angle = angles
      filename = strcat(result_dir,'result',num2str(angle),'.0');
      raw_data = read_complex_binary(filename);

      receive_power = (raw_data'*raw_data)/length(raw_data);
      receive_powers1 = [receive_powers1 receive_power];
      receive_field = sqrt(receive_power);
      receive_fields1 = [receive_fields1 receive_field];

  end

  receive_powers2 = [];
  receive_fields2 = [];
  angles = start_angle:interval_angle:end_angle;
  for angle = angles
      filename = strcat(result_dir,'result',num2str(angle),'.1');
      raw_data = read_complex_binary(filename);

      receive_power = (raw_data'*raw_data)/length(raw_data);
      receive_powers2 = [receive_powers2 receive_power];
      receive_field = sqrt(receive_power);
      receive_fields2 = [receive_fields2 receive_field];

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
  receive_powers1 = receive_powers1./max(receive_powers1);
  receive_fields1 = receive_fields1./max(receive_fields1);
  receive_powers2 = receive_powers2./max(receive_powers2);
  receive_fields2 = receive_fields2./max(receive_fields2);

  % ------------------------------
  % Data vizualization
  % ------------------------------
  theta=(angles)*pi/180;

  figure(1)
  polar(theta,receive_powers1, 'blue');
  hold on;
  polar(theta,receive_powers2,'red');
  hold off;
  title('Power Patterns');
  fig_name = strcat(result_dir,'PowerPatterns ',datestr(now,'yyyymmddTHHMMSS'),'.fig');
  savefig(fig_name);

  figure(2);
  polar(theta,receive_fields1, 'blue');
  hold on;
  polar(theta,receive_fields2,'red');
  hold off;
  title('Field Patterns');
  fig_name = strcat(result_dir,'FieldPatterns ',datestr(now,'yyyymmddTHHMMSS'),'.fig');
  savefig(fig_name);

end
