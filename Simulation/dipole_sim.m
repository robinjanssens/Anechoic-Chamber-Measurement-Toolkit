% =============================================
%
%  Written by Robin Janssens (robin@robinjanssens.net)
%
% =============================================

ant = dipole('Length',0.0864*2,'Width',0.002);
% show(ant);
freq = 868e6;
pattern(ant, freq);
