%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% write2Excel
%
% Diana Zhen Zhang
% IUD: 805777341
%
% Inputs:
%   mesh: a struct of mesh information of the triangulated facets
%   t: a vector of time steps
%   X: an N*3*length(t) matrix, where each pointin the M*3 space
%   corresponds to a local S.I.R. model with the states whose values are
%   between 0 and 1.
%   coord: a 1x3 vector of local vertex's coordinate
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write2Excel(mesh, t, X, filename)

% Initialize and preallocate 
N = numel(t); % Number of steps
numLoc = size(X, 1); % Number of locations

S = zeros(numLoc, 1); % Susceptible rate
I = zeros(numLoc, 1); % Infected rate
R = zeros(numLoc, 1); % Recovered rate

xCoord = zeros(numLoc, 1);
yCoord = zeros(numLoc, 1);
zCoord = zeros(numLoc, 1);

varNames = ["X Coordinate", "Y Coordinate", "Z Coordinate","Susceptible rate", "Infected rate", "Recovered rate"];

targetTime = 0;
n = length(mesh);

for i = 1:N
    if t(i) >= targetTime

        % The size of X is 1178 x 3 x 241
        % (number of elements x number of states x solutions from RK4)

        S(:) = X(:, 1, i); % All the susceptible cases and their solutions per node
        I(:) = X(:, 2, i); % All the infected cases and their solutions per node
        R(:) = X(:, 3, i); % All the recovered cases and their solutions per node

        for j = 1:n
            xCoord(j) = mesh(j).location(:,1); % Get x coordinates from the nodes in the mesh
            yCoord(j) = mesh(j).location(:,2); % Get y coordinates from the nodes in the mesh
            zCoord(j) = mesh(j).location(:,3); % Get z coordinates from the nodes in the mesh
        end

        T = table(xCoord, yCoord, zCoord, S, I, R, 'VariableNames', varNames);
        sheetName = sprintf('T = %f', t(i)); % Name the sheet with the current time
        writetable(T, filename, 'Sheet', sheetName, 'Range', 'A1');

        targetTime = targetTime + 15; % Update the target time
    end
end
end