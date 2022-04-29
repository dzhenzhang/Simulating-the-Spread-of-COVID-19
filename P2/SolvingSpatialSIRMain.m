%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Solving a Spatial SIR Model: Main Script
%
% Diana Zhen Zhang
%
% Main script of solving the spatial SIR model
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc; close all;

%% Load mesh by calling stlRead.m function

fprintf('Calling stlRead to load mesh...\n');

ticStart = tic;
mesh = stlRead('modifiedSphereSTL.txt');
fprintf('Done in %.3f seconds\n', toc(ticStart));

%% Load initial conditions and specify parameters

load('initialValues.mat');
load('SIRparameters.mat');

N = length(mesh);
initialConditions = zeros(N,3);
initialConditions(:,1) = 1; % S
initialConditions(:,2) = 0; % I
initialConditions(:,3) = 0; % R

numInfected = numel(initialInfections);

ticStart = tic;
% Go over each of the infected areas
fprintf('Checking nodes for infection...\n');
for i = 1:numInfected

    % Where in the mesh are there infections?

    for j = 1:N % Check each node for infection
        distance = norm(mesh(j).location - initialInfections{i}); % The distance between infected node at i and mesh node at j
        if distance < 1e-10
            indx = j; % This area is infected
            break
        end
    end
    initialConditions(indx, :) = [0, 1, 0]; % S = 0; I = 1; R = 0
end
fprintf('Done in %.3f seconds\n', toc(ticStart));

% Use the following sequence to plot the nodes and initial infection
% locations to aid with understanding.

% figure(1);
% hold on
% for nodeNum = 1:N
%     loc = mesh(nodeNum).location;
%     plot3(loc(1),loc(2),loc(3),'go');
%     if initialConditions(nodeNum, 2) == 1
%         plot3(loc(1), loc(2), loc(3), 'r*');
%     end
%     view(3)
% end
% hold off
% axis equal

%% solveSpatialSIR with RK4
fprintf('Calling solveSpatialSIR with RK4...\n');
ticStart = tic;

% use RK4.m in solveSpatialSIR.m to solve the system
[tx, x] = solveSpatialSIR(tFinal, mesh, initialConditions, ...
    alpha, beta, gamma, @RK4);
fprintf('Done in %.3f seconds\n', toc(ticStart));

%% solveSpatialSIR with ode45 
fprintf('Calling solveSpatialSIR with ode45...\n');
ticStart = tic;

% use ode45 in solveSpatialSIR.m to solve the system
[ty, y] = solveSpatialSIR(tFinal, mesh, initialConditions, ... 
    alpha, beta, gamma, @ode45);
fprintf('Done in %.3f seconds\n', toc(ticStart));


%% Plot time series at the specified coordinates
fprintf('Calling plotTimeSeries at the specified coordinates...\n');
ticStart = tic;
for i = 1:numel(monitorLocations)
    plotTimeSeries(mesh, tx, x, monitorLocations{i}); % Call plotTimeSeries.m function
end
fprintf('Done in %.3f seconds\n', toc(ticStart));

%% Generate the animation
fprintf('Calling animate to generate the animation...\n');
ticStart = tic;

animate(mesh, tx, x); % Call animate.m function
fprintf('Done in %.3f seconds\n', toc(ticStart));

%% Export to Excel
fprintf('Calling write2Excel to export data...\n');
ticStart = tic;
write2Excel(mesh, tx, x, 'SIRData.xlsx'); % Call write2Excel.m function
fprintf('Done in %.3f seconds', toc(ticStart));