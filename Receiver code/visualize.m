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
  receive_powers = [];
  receive_fields = [];
  angles = start_angle:interval_angle:end_angle;
  for angle = angles
    filename = strcat(result_dir,'result',num2str(angle));
    raw_data = read_complex_binary(filename);

    receive_power = (raw_data'*raw_data)/length(raw_data);
    receive_powers = [receive_powers receive_power];
    receive_field = sqrt(receive_power);
    receive_fields = [receive_fields receive_field];

  end

  % ------------------------------
  % Maximum power
  % ------------------------------
  ideal_angle = sum(angles.*(receive_powers==max(receive_powers)))
  maximum_power_dbm = 10*log10(max(receive_powers)*1000)
  center_power_dbm = 10*log10(receive_powers(round(length(receive_powers)/2))*1000)

  % ------------------------------
  % Normalize values
  % ------------------------------
  receive_powers = receive_powers./max(receive_powers);
  receive_fields = receive_fields./max(receive_fields);

  % ------------------------------
  % Data vizualization
  % ------------------------------
  theta=(angles)*pi/180;

  figure(1)
  polar(theta,receive_powers);
  title('Power Pattern');
  fig_name = strcat(result_dir,'PowerPattern ',datestr(now,'yyyymmddTHHMMSS'),'.fig');
  savefig(fig_name);

  figure(2);
  polar(theta,receive_fields);
  title('Field Pattern');
  fig_name = strcat(result_dir,'FieldPattern ',datestr(now,'yyyymmddTHHMMSS'),'.fig');
  savefig(fig_name);


end
