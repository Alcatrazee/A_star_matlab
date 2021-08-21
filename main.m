% Used for Motion Planning for Mobile Robots
% Thanks to HKUST ELEC 5660
close all; clear all; clc;
addpath('A_star')

% Environment map in 2D space
pos = 10;
xStart = 1.0;
yStart = 1.0;
xTarget = pos;
yTarget = pos;
MAX_X = pos;
MAX_Y = pos;

map = obstacle_map(xStart, yStart, xTarget, yTarget, MAX_X, MAX_Y);
% map = load('map.mat').map;

% Waypoint Generator Using the A*

% W_h = [0 1 0.5 0 1 0.5];
% W_cost = [1 1 1 2 2 2];
% for i = 1:size(W_h,2)
%     time_start = clock();
%     [path,OPEN] = A_star_search(map, MAX_X,MAX_Y,W_h(i),W_cost(i));
%     time_elapsed = etime(clock,time_start);
%     fig = figure(i);
%     title(['W_h:' num2str(W_h(i)) ' ' 'W_c:' num2str(W_cost(i)) ' ' num2str(time_elapsed)])
%     visualize_map(map, path, OPEN);
% end

% run 50 times to obtain mean time
for i = 1:50
    time_start = clock();
    [path,OPEN] = A_star_search(map, MAX_X,MAX_Y,1,1);
    time_elapsed(i) = etime(clock,time_start);
end
visualize_map(map, path, OPEN);
fig = figure();
title(num2str(time_elapsed))
plot(time_elapsed)
mean(time_elapsed)
max(time_elapsed)

% visualize the 2D grid map
% save map
% save('Data/map.mat', 'map', 'MAX_X', 'MAX_Y');
