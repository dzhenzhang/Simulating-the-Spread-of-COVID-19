%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% stlRead
%
% Diana Zhen Zhang
% UID: 805777342
%
% The following function takes the location where a modified stl file (.txt
% format) is stored. It then reads the file and finds the required
% parameters to output "mesh" (an array of structs representing the
% vertices. Each element has members "location" and "neighbors". "location"
% is a 1x3 array of x, y, z coordinates, and "neigbors" is an array of
% indices of the point's neighbors).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function mesh = stlRead(fileLocation)

% Mesh is a struct array where each struct represents a vertex. In each
% struct there is an array of coordinates called 'location' that holds the
% cartesian coordinates that identify the vertex along with an array of
% neighbors that identifies the indices of the neighbors surrounding the
% vertex.

%% Reading in text file
data = readcell(fileLocation, 'Delimiter', '\t') ; 

%% Initialising arrays and matrices to be filled in
uniquePoints = inf(1,3) ; % Empty array of unique vertices in the mesh
mesh = []; % Empty array to be filled with structs representing vertices' location and neighbours

%% Formatting data from text file
% Extracting relevant data from the text file
for i = 1: size(data,1)

    if data{i,1} == "outerLoop" % Finding facets

       % Whenever the contents of the cell in the first column of the row
       % equals "outerLoop", the following three lines will contain useful
       % coordinates

        coord1 = cell2mat(data(i+1, 2:end)); 
        coord2 = cell2mat(data(i+2, 2:end)); 
        coord3 = cell2mat(data(i+3, 2:end)); 

        % Check if the coordinate has already been seen

        if (any(ismember(uniquePoints, coord1, 'rows'))) % There was an equal coordinate found
            idx_p1 = find(ismember(uniquePoints, coord1, 'rows')) - 1; 
        else
            % Find the index
            uniquePoints = [uniquePoints; coord1]; 
            idx_p1 = size(uniquePoints, 1) - 1;  
            
            % Update the mesh
            mesh(end+1).location = coord1; 
            mesh(end).neighbors = []; 
        end


        if (any(ismember(uniquePoints, coord2, 'rows')))
            idx_p2 = find(ismember(uniquePoints, coord2, 'rows')) - 1; 
        else
            uniquePoints = [uniquePoints; coord2]; 
            idx_p2 = size(uniquePoints, 1) - 1;  
            mesh(end+1).location = coord2; 
            mesh(end).neighbors = []; 
        end


        if (any(ismember(uniquePoints, coord3, 'rows')))
            idx_p3 = find(ismember(uniquePoints, coord3, 'rows')) - 1; 
        else
            % Find the index
            uniquePoints = [uniquePoints; coord3]; 
            idx_p3 = size(uniquePoints, 1) - 1;  
            % Update the mesh
            mesh(end+1).location = coord3; 
            mesh(end).neighbors = []; 
        end

        % Add indices of neighbours into the mesh
        mesh(idx_p1).neighbors = union(mesh(idx_p1).neighbors, [idx_p2, idx_p3]) ;
        mesh(idx_p2).neighbors = union(mesh(idx_p2).neighbors, [idx_p1, idx_p3]) ;
        mesh(idx_p3).neighbors = union(mesh(idx_p3).neighbors, [idx_p1, idx_p2]) ;

    end
end
end
