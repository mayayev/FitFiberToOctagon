function [center, semiaxis, tau] = foci2param(F1, F2, s)

a = s/2;
b = sqrt(s^2 - ((F1(1) - F2(1))^2 + (F1(2) - F2(2)))) / 2;
semiaxis = [a b];

center = mean([F1; F2]);

tau = atan2(F2(2) - F1(2), F2(1) - F1(1));
