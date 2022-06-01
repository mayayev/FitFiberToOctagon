function AA = param2conic(center, semiaxis, tau)
c = cos(tau);
s = sin(tau);
a = semiaxis(1);
b = semiaxis(2);
h = center(1);
k = center(2);

A = (b*c)^2 + (a*s)^2;
B = -2*c*s*(a^2-b^2);
C = (b*s)^2 + (a*c)^2;
D = -2*A*h - k*B;
E = -2*C*k - h*B;
F = -(a*b)^2 + A*h^2 + B*h*k + C*k^2;

AA = [A; B; C; D; E; F];