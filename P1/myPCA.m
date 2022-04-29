%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% myPCA
%
% Diana Zhen Zhang
%
% myPCA analyzes the principal components of given COVID-19 statistical 
% data from multiple countries - covid_countries.csv
%
% Inputs:
% data: A nxp matrix representing only the numerical parts of the dataset
%
% Outputs:
% coeffOrth: a pxp matrix whose columns are the eigenvectors corresponding 
% to the sorted eigenvalues
% pcaData: a nxp matrix representing the data projected onto the principal components
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [coeffOrth, pcaData] = myPCA(data)

%% Data Standarditazion 
% Calculate the mean of each column
means = zeros(1,4); 
for i = 1:4
    means(i) = myMean(data(:,i));
end

% Calculate the standard deviation of each column
stdev = zeros(1,4);
for i = 1:4
    stdev(i) = myStdev(data(:,i));
end

% Normalizing data
XNorm = (data - means) ./ stdev;
   
% Covariance Matrix computation
C = (XNorm' * XNorm) / (27 -1);

% Find eigenvalues and eigenvectors
[eigVec,eigVal] = eig(C);

[~, idx] = sort(diag(eigVal),'descend'); % Sorting in descending order
eigVecSort = eigVec(:,idx);

coeffOrth = eigVecSort;

% Normalized Data Projection
pcaData = XNorm * eigVecSort;

%% Mean computation function
    function [mean] = myMean(data)

        mean = sum(data,1)/length(data);

    end

%% Standard deviation computation function
    function [stdev] = myStdev(data)

        mean = sum(data,1)/numel(data);

        for j = 1:numel(data)
            stdev = sqrt(sum((data-mean).^2)/(numel(data)-1));
        end

    end
end