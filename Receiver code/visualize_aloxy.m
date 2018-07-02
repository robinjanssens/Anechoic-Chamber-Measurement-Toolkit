% =============================================
%
%  Function to visualize raw data from antenna measurements
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================
function visualize(result_dir,result_dir2,start_angle,interval_angle,end_angle)

  % ------------------------------
  % Data Processing
  % ------------------------------
  receive_powers1 = [];
  receive_fields1 = [];
  angles = start_angle:interval_angle:end_angle;
  for angle = angles
      filename = strcat(result_dir,'result',num2str(angle));
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
      filename = strcat(result_dir2,'result',num2str(angle));
      raw_data = read_complex_binary(filename);

      receive_power = (raw_data'*raw_data)/length(raw_data);
      receive_powers2 = [receive_powers2 receive_power];
      receive_field = sqrt(receive_power);
      receive_fields2 = [receive_fields2 receive_field];

  end

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
  polar(theta,receive_powers1);
  title('Power Pattern 1');
  fig_name = strcat(result_dir,'PowerPattern1 ',datestr(now,'yyyymmddTHHMMSS'),'.fig');
  savefig(fig_name);

  figure(2);
  polar(theta,receive_fields1);
  title('Field Pattern 1');
  fig_name = strcat(result_dir,'FieldPattern1 ',datestr(now,'yyyymmddTHHMMSS'),'.fig');
  savefig(fig_name);

  figure(3)
  polar(theta,receive_powers2);
  title('Power Pattern 2');
  fig_name = strcat(result_dir,'PowerPattern2 ',datestr(now,'yyyymmddTHHMMSS'),'.fig');
  savefig(fig_name);

  figure(4);
  polar(theta,receive_fields2);
  title('Field Pattern 2');
  fig_name = strcat(result_dir,'FieldPattern2 ',datestr(now,'yyyymmddTHHMMSS'),'.fig');
  savefig(fig_name);

end
