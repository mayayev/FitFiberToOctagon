function [center, semiaxis, tau] = conic2param(A)

a = A(1); b = A(2)/2; c = A(3); d = A(4)/2; f = A(5)/2; g = A(6);

center(1) = (c*d - b*f)/(b^2-a*c); 
center(2) = (a*f - b*d)/(b^2-a*c);

semiaxis(1) = sqrt( 2*(a*f^2+c*d^2+g*b^2-2*b*d*f-a*c*g) / ((b^2-a*c)*(sqrt((a-c)^2+4*b^2)-(a+c)))); 
semiaxis(2) = sqrt( 2*(a*f^2+c*d^2+g*b^2-2*b*d*f-a*c*g) / ((b^2-a*c)*(-sqrt((a-c)^2+4*b^2)-(a+c))));

if b == 0 && a < c 
 tau = 0; 
elseif b == 0 && a > c 
 tau = 0.5*pi; 
elseif b ~= 0 && a < c 
 tau = 0.5* acot((a-c)/(2*b)); 
else 
 tau = 0.5*pi + 0.5* acot((a-c)/(2*b)); 
end
