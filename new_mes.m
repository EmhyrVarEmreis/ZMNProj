close all;
clear;
clc;

dim = [ 8.00 10.00 ]; % board size [x y]
net_step = [ 0.5 0.5 ]*2; % net steps => [normal accurate]
E = [ 0.50 0.75 ]; % eps => [eps1 eps2]
V = [ 0.50 0.75 ]; % V => [V1 V2]

% shield
s_d = 2; % thickness
s_pos = [ 1.00 1.00 ]; % position => [x, y]
s_dim = [ 6.00 6.00 ]; % thickness => [xt yt]

xs = [ ...
    0:net_step(1):s_pos(1) ...
    s_pos(1):net_step(2):(s_pos(1) + s_d) ...
    (s_pos(1) + s_d):net_step(1):(s_pos(1) + s_dim(1) - s_d) ...
    (s_pos(1) + s_dim(1) - s_d):net_step(2):(s_pos(1) + s_dim(1)) ...
    (s_pos(1) + s_dim(1)):net_step(1):dim(1)];
ys = [ ...
    0:net_step(1):s_pos(2) ...
    s_pos(2):net_step(2):(s_pos(2) + s_d) ...
    (s_pos(2) + s_d):net_step(1):(s_pos(2) + s_dim(2) - s_d) ...
    (s_pos(2) + s_dim(2) - s_d):net_step(2):(s_pos(2) + s_dim(2)) ...
    (s_pos(2) + s_dim(2)):net_step(1):dim(2)];

xs = unique(xs.','rows');
ys = unique(ys.','rows');

x = size(xs, 1);
y = size(ys, 1);

[X,Y] = meshgrid(xs, ys);
W = [X(:) Y(:)];

m = size(W, 1);
N = 1:1:m;
N = reshape(N, y , x); 

TRI = zeros((x-1)*(y-1)*2, 3);
for i = 1:1:x-1
    tri_lower = [N(1:end-1, i) N(1:end-1, i+1) N(2:end, i)];
    tri_upper = [N(1:end-1, i+1) N(2:end, i+1) N(2:end, i)];
    TRI((i-1)*2*(y-1)+1:i*2*(y-1),:) = [tri_lower; tri_upper];
end

triplot(TRI, W(:, 1), W(:, 2), 'Color', [0.5 0.5 0.5]), hold on;
rectangle('Position', [s_pos s_dim], 'LineWidth', 2, 'EdgeColor', 'k'), hold on;
rectangle('Position', [s_pos+s_d s_dim-2*s_d], 'LineWidth', 2, 'EdgeColor', 'k'), hold on;
plot([dim(1) dim(1)], [0 dim(2)], 'Color', 'r', 'LineWidth', 2), hold on;
plot([s_pos(1)+s_d s_pos(1)+s_d], [s_pos(2)+s_d s_pos(2)-s_d+s_dim(2)], 'Color', 'r', 'LineWidth', 2), hold on;