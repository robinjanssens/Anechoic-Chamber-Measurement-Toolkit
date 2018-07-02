% =============================================
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================

ant = dipole('Height',0.0864,'Width',0.002,'GroundPlaneLength',10,'GroundPlaneWidth',10);
% show(ant);
freq = 868e6;
pattern(ant, freq);
