function [F1, F2, s] = param2foci(center, semiaxis, tau)

if semiaxis(1) > semiaxis(2)
    a = semiaxis(1);
    b = semiaxis(2);
else
    a = semiaxis(2);
    b = semiaxis(1);
end

c = sqrt(a^2 - b^2);

F1(1) = center(1) - cos(tau)*c;
F1(2) = center(2) - sin(tau)*c;

F2(1) = center(1) + cos(tau)*c;
F2(2) = center(2) + sin(tau)*c;

s = 2*a;