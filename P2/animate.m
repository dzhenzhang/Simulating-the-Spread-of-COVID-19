%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% animate: shows the change in the ratio of susceptible, infected, and 
% recovered individuals in the grid as an image.
%
% Diana Zhen Zhang
% IUD: 805777341
%
% Inputs:
% mesh: an struct of mesh information of the triangulated surface
% t: the time vector
% X: an N*3*length(t) matrix, where each Nx3 matrix corresponds to
% the state of the S.I.R. system at a particular instance in time.
% This 2D matrix is repeated for each time step, making it a 3D 
% matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function animate(mesh, t, X)

N = length(mesh); % Number of nodes
coords = zeros(N,3); % Coordinates of the nodes in mesh
colors = zeros(size(X)); % Colors representing S, I, and R

for i = 1:N % For each node in the mesh
    coords(i,:) = mesh(i).location; 
end

colors(:,1,:) = X(:, 2, :); % Red for infected
colors(:,2,:) = X(:, 3, :); % Green for recovered
colors(:,3,:) = X(:, 1, :); % Red for susceptible

figure;
% plot once for every unit of time

tCurrent = 0; % Current time
d = 20;

for i = 1:length(t) % loop over time
    if t(i) >= tCurrent
        %Plot it 
        pcshow(coords, colors(:,:,i),'MarkerSize',500);

        % Label axes
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        
        drawnow
        pause(0.1);

        tCurrent = tCurrent + 0.1 * d; % Update the current time in order to progress through the coordinates
    end
  
end
end

        