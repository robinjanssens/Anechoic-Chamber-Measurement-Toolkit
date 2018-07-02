% =============================================
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================

angles=0:179;
theta=angles*pi/180;
F=abs(cos(cos(theta)*pi/2)./sin(theta));
P=abs(cos(cos(theta)*pi/2)./sin(theta)).^2;

figure(1);
polar(theta-(pi/2),P);
title("Power Pattern");

figure(2);
polar(theta-(pi/2),F);
title("Field Pattern");

% figure(1);
% polar(0:2*pi/360:2*pi,ones(1,361));
% title("Power Pattern");
%
% figure(2);
% polar(0:2*pi/360:2*pi,ones(1,361));
% title("Field Pattern");
