function [AF] = ArrayFactor (d, N, thetha_zero)
An = 1;
AF = zeros (1,360);
for thetha = 1: 360
     % convert degrees to radians
     deg2rad(thetha)=(thetha*pi)/180;
     % array factor is a sum of the N elements
     for n=0:N-1
         AF(thetha)=AF(thetha)+An*exp(1i*n*2*pi*d*(cos(deg2rad(thetha))-cos(thetha_zero (n + 1) * pi / 180)));
     end
     % considers only the real part of the array factor
     AF (thetha) = abs (AF (thetha));
end
end
