%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% RK4: Bogacki-Shampine method of RK4 with adaptive step size
%
% Diana Zhen Zhang
% IUD: 805777341
%
% Inputs:
% f: function handle of f(t, y)
% tspan: the time period for simulation (should be a 1x2 array contain 
% start time and end time)
% y0: the initial conditions for the differential equation
% 
% Outputs:
% t: corresponding time sequence as a T x 1 vector
% y: the solution of the differential equation as a T x n matrix,
% where T is the number of time steps and n is the dimension of y
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [t, y] = RK4(f, tspan, y0)

% Initialization and declaration
y(:,1) = y0;
t(1) = tspan(1); % t will be a giant column vector

e0 = 1e-4;

yk = y0;
hk = 0.1;
tk = tspan(1);

% Loop through RK method
while tk < tspan(2)
    hk = min(hk, tspan(2) - tk);
    tkp1 = tk + hk;
    k1 = f(tk, yk);
    k2 = f(tk + 0.5*hk, yk + 0.5*hk*k1);
    k3 = f(tk + 0.75*hk, yk + 0.75*hk*k2);

    ykp1 = yk + (2/9)*hk*k1 + (1/3)*hk*k2 + (4/9)*hk*k3;

    k4 = f(tk + hk, ykp1);
    
    zkp1 = yk + (7/24)*hk*k1 + (1/4)*hk*k2 + (1/3)*hk*k3 + (1/8)*hk*k4;

    t = [t;tkp1];
    y = [y,ykp1];

    ekp1 = vecnorm(ykp1 - zkp1);
    hkp1 = hk * (e0/ekp1)^0.2;
    
    % Update values
    hk = hkp1;
    tk = tkp1;
    yk = ykp1;
end

y = y';

end