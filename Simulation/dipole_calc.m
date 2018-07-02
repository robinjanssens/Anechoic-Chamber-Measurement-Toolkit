% =============================================
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================

angles=0:179;
theta=angles*pi/180;
F = (cos(pi/2*cos(theta))./sin(theta)); % half-wave dipole
% F=ones(1,length(theta));
% F = sin(theta);

polar(theta,F)
figure()
plot(angles,F)
