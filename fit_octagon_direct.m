function [enclosing,enclosed] = fit_octagon_direct(points)

%% smallest enclosing ellipsoid
ch = [points(convhull(points),1) points(convhull(points),2)];
[A, enclosing.center] = MinVolEllipse(ch', 1e-3);

[Ve,De] = eig(A); 
De = sqrt(diag(De)); 
[enclosing.semiaxis,Ie] = max(De); 
veig = Ve(:,Ie); 
enclosing.tau = atan2(veig(2),veig(1)); 
enclosing.semiaxis(2) = De(setdiff([1 2],Ie)); 


%% largest contained ellipse
A_direct = EllipseDirectFit(points);
[center_direct, semiaxis_direct, tau_direct] = conic2param(A_direct);
[F1, F2, ~] = param2foci(center_direct, semiaxis_direct, tau_direct);

d = sqrt((points(:,1) - F1(1)).^2 + (points(:,2) - F1(2)).^2) + sqrt((points(:,1) - F2(1)).^2 + (points(:,2) - F2(2)).^2);
s_new = min(d);
[enclosed.center, enclosed.semiaxis, enclosed.tau] = foci2param(F1, F2, s_new);

