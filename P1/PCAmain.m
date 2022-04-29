%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Principal Component Analysis Main Script
%
% Diana Zhen Zhang
%
% Main script of solving the spatial SIR model
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc; close all;

data = readtable('covid_countries.csv','VariableNamingRule','preserve');
dataDuct = table2array(data(:,3:end));

% Get column titles
vbls = data.Properties.VariableNames;
vbls = vbls(3:end);

% Call myPCA function to obtain data
[coeffOrth1, pcaData1] = myPCA(dataDuct);

% Only take first two columns of data
pcaData2D = pcaData1(:,1:2);
E2D = coeffOrth1(:,1:2);

% Plot the data
biplot(E2D,"Scores",pcaData2D,"VarLabels",vbls);
title('Covid Countries PCA Data');
