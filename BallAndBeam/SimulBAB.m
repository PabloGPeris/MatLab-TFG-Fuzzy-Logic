function respuesta = SimulBAB(u, x, alpha, xd, alphad)
%SIMULBAB

global a b m l;


xdd_num = a(2)*((b(2)*xd*x + b(3))*alphad + b(4)*alpha - b(6)*x*cos(alpha)) + (m*x^2 + b(1))*(a(3)*sin(alpha) + m*x*alphad^2) - a(2)*l*cos(alpha)*u;
xdd_denom = a(1)*(m * x^2 + b(1)) -a(2) * b(5);
xdd = xdd_num / xdd_denom;
alphadd_num = - ((b(2)*xd*x + b(3))*alphad + b(4)*alpha + b(5) * xdd) + b(6)*x*cos(alpha) + u*l*cos(alpha); 
alphadd_denom = m*x^2 + b(1);
alphadd = alphadd_num/alphadd_denom;
respuesta=[xdd; alphadd];
end

