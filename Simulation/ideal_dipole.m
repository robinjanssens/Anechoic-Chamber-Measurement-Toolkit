% =============================================
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================

angles=0:360
theta=angles*pi/180
F=ones(1,length(theta)); %sin(theta);

figure; polar(theta,F)
figure; plot(angles,F)
