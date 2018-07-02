% =============================================
%
%  Function to visualize raw data from antenna measurements
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================
function visualize_3D(result_dir,start_pan_angle,interval_pan_angle,end_pan_angle,start_tilt_angle,interval_tilt_angle,end_tilt_angle)

  % ------------------------------
  % Data Processing
  % ------------------------------
  receive_powers = [];
  pan_angles  = start_pan_angle:interval_pan_angle:end_pan_angle;
  tilt_angles = start_tilt_angle:interval_tilt_angle:end_tilt_angle;
  for i = 1:length(pan_angles)
    for j = 1:length(tilt_angles)
      filename = strcat(result_dir,'result(',num2str(pan_angles(i)),')(',num2str(tilt_angles(j)),')');
      raw_data = read_complex_binary(filename);
      receive_power = raw_data'*raw_data;
      receive_powers(i,j) = receive_power;
    end
  end

  % ------------------------------
  % Maximum power
  % ------------------------------
  maximum_power_dbm = 10*log10(max(max(receive_powers))*1000)

  % ------------------------------
  % Normalize values
  % ------------------------------
  receive_powers = receive_powers./max(receive_powers);

  % ------------------------------
  % Convert spherical to cartesian coordinates
  % ------------------------------
  pan_theta=pan_angles*pi/180;
  tilt_theta=tilt_angles*pi/180;
  [a,e] = meshgrid(pan_theta,tilt_theta);
  [X,Y,Z] = sph2cart(a,e,receive_powers');
  Y=-Y;
  Z=-Z;
  mag_R=sqrt(X.^2+Y.^2+Z.^2);

  % ------------------------------
  % Data vizualization
  % ------------------------------
  surf(X,Y,Z,mag_R,'EdgeColor','none','FaceColor','interp')
  colormap(jet);
  title('Power Pattern');
  fig_name = strcat(result_dir,'3DPowerPattern ',datestr(now,'yyyymmddTHHMMSS'),'.fig');
  savefig(fig_name);

end
