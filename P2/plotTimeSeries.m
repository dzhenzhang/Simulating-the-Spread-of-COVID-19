%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% plotTimeSeries
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

function plotTimeSeries(mesh, t, X, coord)

% Obtain individual elements of the location given in the input
x = coord(:,1,1);
y = coord(:,2,1);
z = coord(:,3,1);

% Find index of the coordinate given
locIndx = ismember(vertcat(mesh.location), coord, 'rows');
SIR = X(locIndx,:,:);

% Isolate the data for S, I, and R to store in separate arrays
susceptible = [];
infected = [];
recovered = [];

for i = 1:length(SIR)
    susceptible(i) = SIR(:,1,i);
    infected(i) = SIR(:,2,i);
    recovered(i) = SIR(:,3,i);
end

f = figure(1);

% Plot susceptible
subplot(3,1,1);
plot(t,susceptible,'b-');
xlabel('Time');
ylabel('Ratio of Susceptible');
xlim([0 max(t)]); % x axis displays numbers from 0 to the maximum time elapsed

% Plot infected
subplot(3,1,2);
plot(t,infected,'r-');
xlabel('Time');
ylabel('Ratio of Infected');
xlim([0 max(t)]); % x axis displays numbers from 0 to the maximum time elapsed

% Plot recovered
subplot(3,1,3);
plot(t,recovered,'g-');
xlabel('Time');
ylabel('Ratio of Recovered');
xlim([0 max(t)]); % x axis displays numbers from 0 to the maximum time elapsed

% Save plot as .png file
title = sprintf('time_series_%.3f_%.3f_%.3f',x,y,z);
saveas(f,sprintf('%s.png',title));

end
