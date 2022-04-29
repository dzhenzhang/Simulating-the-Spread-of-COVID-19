%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dynamicsSIR: Compute the rate of change of the model
%
% Diana Zhen Zhang
% IUD: 805777341
%
% Inputs:
% x: vectorized state
% mesh: the underlying mesh
% alpha, beta, gamma: model parameters
%
% Output:
% dxdt: vectorized time derivative of state
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function dxdt = dynamicsSIR(x, mesh, alpha, beta, gamma)

% Reshaping matrices
N = length(mesh); % number of nodes, in this case they are the rows
matReshaped = reshape(x,[N,3]); % 3 is used because there are three states (S, I, and R)

S = matReshaped(:,1);
I = matReshaped(:,2);
% R = matReshaped(:,3); Commented for understanding, but unused

% Calculate dynamics
derivatives = zeros(N,3); % Preallocate derivatives array

for i = 1:N
    nbrContr = 0; % Initialize neighbor contribution per loop
    n = length(mesh(i).neighbors); % Number of neighbors

    for j = 1:n 
        nbrContr = nbrContr + I(mesh(i).neighbors(j)) / vecnorm(mesh(mesh(i).neighbors(j)).location - mesh(i).location); % Computing the distance between two points
    end

    % Differentiate
    derivatives(i,1) = -(beta*I(i) + alpha/n * nbrContr) * S(i);
    derivatives(i,2) = (beta*I(i) + alpha/n * nbrContr) * S(i) - gamma*I(i);
    derivatives(i,3) = gamma*I(i);
end

% Vectorize derivatives
dxdt = derivatives(:);

end


