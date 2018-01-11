close all;
clear;
clc;

dim = [ 10.00 10.00 ]; % board size [x y]
net_step = [ 0.5 0.25 ]; % net steps => [normal accurate]
E = [ 0.50 0.75 ]; % eps => [eps1 eps2]
V = [ 0.50 0.75 ]; % V => [V1 V2]

% shield
s_d = 1.5; % thickness
s_pos = [ 1.00 1.00 ]; % position => [x, y]
s_dim = [ 6.00 8.00 ]; % thickness => [xt yt]
s_bor = [ s_pos s_pos+s_dim; s_pos+s_d s_pos+s_dim-s_d];
s_pol = [ ...
    s_bor(1, 1) s_bor(1, 1) s_bor(1, 3) s_bor(1, 3) s_bor(1, 1); ...
    s_bor(1, 2) s_bor(1, 4) s_bor(1, 4) s_bor(1, 2) s_bor(1, 2); ...
    s_bor(2, 1) s_bor(2, 1) s_bor(2, 3) s_bor(2, 3) s_bor(2, 1); ...
    s_bor(2, 2) s_bor(2, 4) s_bor(2, 4) s_bor(2, 2) s_bor(2, 2)];

xs = [ ...
    0:net_step(1):s_bor(1, 1) ...
    s_bor(1, 1):net_step(2):s_bor(2, 1) ...
    s_bor(2, 1):net_step(1):s_bor(2, 3) ...
    s_bor(2, 3):net_step(2):s_bor(1, 3) ...
    s_bor(1, 3):net_step(1):dim(1)];
ys = [ ...
    0:net_step(1):s_bor(1, 2) ...
    s_bor(1, 2):net_step(2):s_bor(2, 2) ...
    s_bor(2, 2):net_step(1):s_bor(2, 4) ...
    s_bor(2, 4):net_step(2):s_bor(1, 4) ...
    s_bor(1, 4):net_step(1):dim(2)];

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
z = size(TRI, 1);

triplot(TRI, W(:, 1), W(:, 2), 'Color', [0.5 0.5 0.5]), axis equal, axis([0 dim(1) 0 dim(2)]), hold on;
rectangle('Position', [s_pos s_dim], 'LineWidth', 2, 'EdgeColor', 'k'), hold on;
rectangle('Position', [s_pos+s_d s_dim-2*s_d], 'LineWidth', 2, 'EdgeColor', 'k'), hold on;
plot([dim(1) dim(1)], [0 dim(2)], 'Color', 'r', 'LineWidth', 2), hold on;
plot(s_bor(2, 1:2), s_bor(2, 1:2)+[0 -s_d*2+s_dim(2)], 'Color', 'b', 'LineWidth', 2), hold on;

% shield area
[s_pol_x, s_pol_y] = polybool('subtraction', s_pol(1, :), s_pol(2, :), s_pol(3, :), s_pol(4, :));
in = inpolygon(W(:,1), W(:,2), s_pol_x, s_pol_y);
s_tri = zeros(z, 3);
t = 0;
for i = 1:1:z
    if in(TRI(i, 1)) == 1 && in(TRI(i, 2)) == 1 && in(TRI(i, 3)) == 1
        t = t + 1;
        s_tri(t, :) = TRI(i, :);
    end
end
s_tri = s_tri(1:t, :); % triangles inside shield walls/borders

% initializing H matrix
H = zeros(m);
for i = 1:1:z
    t = TRI(i,:);
    if ismember(t, s_tri, 'rows') == 1
        e_tmp = E(2);
    else
        e_tmp = E(1);
    end
    p = [ W(t(1), :); W(t(2), :); W(t(3), :) ];
    he = getHe(p, e_tmp);
    H(TRI(i, 1:3), TRI(i, 1:3)) = H(TRI(i, 1:3), TRI(i, 1:3)) + he;
end

source_points_v1 = zeros(30, 1);
source_points_v2 = zeros(30, 1);
t1 = 1;
t2 = 1;
for i = 1:1:m
    tmp = W(i, :);
    if tmp(1) == s_bor(2, 1) && tmp(2) >= s_bor(2, 1) && tmp(2) <= (s_bor(2, 1) - s_d*2 + s_dim(2))
        source_points_v1(t1) = i;
        t1 = t1 + 1;
    elseif tmp(1) == dim(1)
        source_points_v2(t2) = i;
        t2 = t2 + 1;
    end
end
source_points_v1 = source_points_v1(1:(t1 - 1));
source_points_v2 = source_points_v2(1:(t2 - 1));
source_points_all = [source_points_v1; source_points_v2];

VV = zeros(m, 1);

VV(source_points_v1) = V(1);
VV(source_points_v2) = V(2);

for i = 1:1:size(source_points_all, 1)
    source_points = source_points_all(i);
    H(source_points, :) = 0;
    H(source_points, source_points) = 1;
end

B = H \ VV;
figure(2);
trimesh(TRI , W(:,1) , W(:,2),B);

figure(3)
contour(xs, ys, reshape(B, y, x), 20);