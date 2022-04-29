%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% solveSpatialSIR: Solve the spatial SIR model
%
% Diana Zhen Zhang
% IUD: 805777341
%
% Inputs:
% tFinal: end time for the simulation (assuming start is t=0)
% mesh: the underlying mesh
% initialCondition: a Nx3 matrix that sums to 1 in third dimension
% alpha, beta, gamma: model parameters
% odeSolver: a function handle for an ode45-compatible solver
%
% Outputs:
% t: a vector of the time-steps
% x: Nx3xlength(t) matrix representing the state vs. time
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [t,x] = solveSpatialSIR(tFinal, mesh, initialCondition, alpha, beta, gamma, odeSolver)

% The rate of spread is constant throughout the year, t is not used in
% dSIRdt function

dSIRdt = @(t,x) dynamicsSIR(x, mesh, alpha ,beta ,gamma);

[t, y] = odeSolver(dSIRdt, [0, tFinal], initialCondition(:));

N = length(mesh);
x = zeros(N,3,length(t));
for i = 1:length(t)

    localSol = y(i,:); % Solution at step i
    reshapedLocalSol = reshape(localSol, [N,3]); % Reshape local solution form array to Nx3 matrix
    x(:,:,i) = reshapedLocalSol; % Load into x matrix
end
end



