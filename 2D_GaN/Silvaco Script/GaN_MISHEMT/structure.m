% This script is used for generating a GaN MISHEMT structure points

clc,clear
close all

% Some general values of the GaN MISHEMT
x1 = 0.5;
x2 = 1.0;
x3 = 0.2;
x4 = 0.15;
x5 = 2.0;
x6 = 0.15;
x7 = 1.2;
x8 = 4.3;
x9 = 0.5;

y1 = 0.015;
y2 = 0.01;
y3 = 0.009;
y4 = 0.004;
y5 = 0.001;
y6 = 0.0015;
y7 = 0.001;
y8 = 0.2;
y9 = 0.007;
y0 = 0.15;

num = 9;
regions = repmat(RegionPoints, num, 1);

% Source region
regions(1) = regions(1).regionpoints(5);
regions(1).coord(1, 1) = 0;
regions(1).coord(1, 2) = -(y7 + y6 + y5 + y4 + y3 + y2 + y1);
regions(1).coord(2, 1) = x1;
regions(1).coord(2, 2) = -(y7 + y6 + y5 + y4 + y3 + y2 + y1);
regions(1).coord(3, 1) = x1;
regions(1).coord(3, 2) = -(y7 + y6 + y5 + y4);
regions(1).coord(4, 1) = 0;
regions(1).coord(4, 2) = -(y7 + y6 + y5 + y4);
regions(1).coord(5, 1) = 0;
regions(1).coord(5, 2) = -(y7 + y6 + y5 + y4 + y3 + y2 + y1);

% Gate region
regions(2) = regions(2).regionpoints(9);
regions(2).coord(1, 1) = x1 + x2;
regions(2).coord(1, 2) = -(y7 + y6 + y5 + y4 + y3 + y2 + y1);
regions(2).coord(2, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7;
regions(2).coord(2, 2) = -(y7 + y6 + y5 + y4 + y3 + y2 + y1);
regions(2).coord(3, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7;
regions(2).coord(3, 2) = -(y7 + y6 + y5 + y4 + y3 + y2);
regions(2).coord(4, 1) = x1 + x2 + x3 + x4 + x5;
regions(2).coord(4, 2) = -(y7 + y6 + y5 + y4 + y3 + y2);
regions(2).coord(5, 1) = x1 + x2 + x3 + x4 + x5;
regions(2).coord(5, 2) = -(y7 + y6 + y5);
regions(2).coord(6, 1) = x1 + x2 + x3 + x4;
regions(2).coord(6, 2) = -(y7 + y6 + y5);
regions(2).coord(7, 1) = x1 + x2 + x3 + x4;
regions(2).coord(7, 2) = -(y7 + y6 + y5 + y4 + y3 + y2);
regions(2).coord(8, 1) = x1 + x2;
regions(2).coord(8, 2) = -(y7 + y6 + y5 + y4 + y3 + y2);
regions(2).coord(9, 1) = x1 + x2;
regions(2).coord(9, 2) = -(y7 + y6 + y5 + y4 + y3 + y2 + y1);

% Drain region
regions(3) = regions(3).regionpoints(5);
regions(3).coord(1, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8;
regions(3).coord(1, 2) = -(y7 + y6 + y5 + y4 + y3 + y2 + y1);
regions(3).coord(2, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(3).coord(2, 2) = -(y7 + y6 + y5 + y4 + y3 + y2 + y1);
regions(3).coord(3, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(3).coord(3, 2) = -(y7 + y6 + y5 + y4);
regions(3).coord(4, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8;
regions(3).coord(4, 2) = -(y7 + y6 + y5 + y4);
regions(3).coord(5, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8;
regions(3).coord(5, 2) = -(y7 + y6 + y5 + y4 + y3 + y2 + y1);

% Oxide region
regions(4) = regions(4).regionpoints(13);
regions(4).coord(1, 1) = x1;
regions(4).coord(1, 2) = -(y7 + y6 + y5 + y4 + y3 + y2);
regions(4).coord(2, 1) = x1 + x2 + x3 + x4;
regions(4).coord(2, 2) = -(y7 + y6 + y5 + y4 + y3 + y2);
regions(4).coord(3, 1) = x1 + x2 + x3 + x4;
regions(4).coord(3, 2) = -(y7 + y6 + y5);
regions(4).coord(4, 1) = x1 + x2 + x3 + x4 + x5;
regions(4).coord(4, 2) = -(y7 + y6 + y5);
regions(4).coord(5, 1) = x1 + x2 + x3 + x4 + x5;
regions(4).coord(5, 2) = -(y7 + y6 + y5 + y4 + y3 + y2);
regions(4).coord(6, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8;
regions(4).coord(6, 2) = -(y7 + y6 + y5 + y4 + y3 + y2);
regions(4).coord(7, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8;
regions(4).coord(7, 2) = -(y7 + y6 + y5 + y4 + y3);
regions(4).coord(8, 1) = x1 + x2 + x3 + x4 + x5 + x6;
regions(4).coord(8, 2) = -(y7 + y6 + y5 + y4 + y3);
regions(4).coord(9, 1) = x1 + x2 + x3 + x4 + x5 + x6;
regions(4).coord(9, 2) = -(y7 + y6);
regions(4).coord(10, 1) = x1 + x2 + x3;
regions(4).coord(10, 2) = -(y7 + y6);
regions(4).coord(11, 1) = x1 + x2 + x3;
regions(4).coord(11, 2) = -(y7 + y6 + y5 + y4 + y3);
regions(4).coord(12, 1) = x1;
regions(4).coord(12, 2) = -(y7 + y6 + y5 + y4 + y3);
regions(4).coord(13, 1) = x1;
regions(4).coord(13, 2) = -(y7 + y6 + y5 + y4 + y3 + y2);

% Charge given region
regions(5) = regions(5).regionpoints(13);
regions(5).coord(1, 1) = 0;
regions(5).coord(1, 2) = -(y7 + y6 + y5 + y4);
regions(5).coord(2, 1) = x1;
regions(5).coord(2, 2) = -(y7 + y6 + y5 + y4);
regions(5).coord(3, 1) = x1;
regions(5).coord(3, 2) = -(y7 + y6 + y5 + y4 + y3);
regions(5).coord(4, 1) = x1 + x2 + x3;
regions(5).coord(4, 2) = -(y7 + y6 + y5 + y4 + y3);
regions(5).coord(5, 1) = x1 + x2 + x3;
regions(5).coord(5, 2) = -(y7 + y6);
regions(5).coord(6, 1) = x1 + x2 + x3 + x4 + x5 + x6;
regions(5).coord(6, 2) = -(y7 + y6);
regions(5).coord(7, 1) = x1 + x2 + x3 + x4 + x5 + x6;
regions(5).coord(7, 2) = -(y7 + y6 + y5 + y4 + y3);
regions(5).coord(8, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8;
regions(5).coord(8, 2) = -(y7 + y6 + y5 + y4 + y3);
regions(5).coord(9, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8;
regions(5).coord(9, 2) = -(y7 + y6 + y5 + y4);
regions(5).coord(10, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(5).coord(10, 2) = -(y7 + y6 + y5 + y4);
regions(5).coord(11, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(5).coord(11, 2) = -(y7);
regions(5).coord(12, 1) = 0;
regions(5).coord(12, 2) = -(y7);
regions(5).coord(13, 1) = 0;
regions(5).coord(13, 2) = -(y7 + y6 + y5 + y4);

% Barrier region
regions(6) = regions(6).regionpoints(5);
regions(6).coord(1, 1) = 0;
regions(6).coord(1, 2) = -(y7);
regions(6).coord(2, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(6).coord(2, 2) = -(y7);
regions(6).coord(3, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(6).coord(3, 2) = 0;
regions(6).coord(4, 1) = 0;
regions(6).coord(4, 2) = 0;
regions(6).coord(5, 1) = 0;
regions(6).coord(5, 2) = -(y7);

% Drift region
regions(7) = regions(7).regionpoints(5);
regions(7).coord(1, 1) = 0;
regions(7).coord(1, 2) = 0;
regions(7).coord(2, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(7).coord(2, 2) = 0;
regions(7).coord(3, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(7).coord(3, 2) = y8;
regions(7).coord(4, 1) = 0;
regions(7).coord(4, 2) = y8;
regions(7).coord(5, 1) = 0;
regions(7).coord(5, 2) = 0;

% Transition region
regions(8) = regions(8).regionpoints(5);
regions(8).coord(1, 1) = 0;
regions(8).coord(1, 2) = y8;
regions(8).coord(2, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(8).coord(2, 2) = y8;
regions(8).coord(3, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(8).coord(3, 2) = y8 + y9;
regions(8).coord(4, 1) = 0;
regions(8).coord(4, 2) = y8 + y9;
regions(8).coord(5, 1) = 0;
regions(8).coord(5, 2) = y8;

% Substrate region
regions(9) = regions(9).regionpoints(5);
regions(9).coord(1, 1) = 0;
regions(9).coord(1, 2) = y8 + y9;
regions(9).coord(2, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(9).coord(2, 2) = y8 + y9;
regions(9).coord(3, 1) = x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9;
regions(9).coord(3, 2) = y8 + y9 + y0;
regions(9).coord(4, 1) = 0;
regions(9).coord(4, 2) = y8 + y9 + y0;
regions(9).coord(5, 1) = 0;
regions(9).coord(5, 2) = y8 + y9;

% Plot the sturcture and verify it
figure
hold on
% axis equal
colors = [0.635 0.078 0.184
             0.635 0.078 0.184
             0.635 0.078 0.184
             0.301 0.745 0.933
             0.850 0.325 0.098
             0.466 0.674 0.188
             0.301 0.745 0.933
             0.466 0.674 0.188
             0.920 0.694 0.125];
for i = 1 : num
    fill(regions(i).coord(:, 1), regions(i).coord(:, 2), colors(i, :));
end

% Put these points into dat file for devedit script
fid = fopen('structure.dat', 'w+');
for i = 1 : num
    fprintf(fid, '%s', '"');
    for j = 1 : regions(i).points
        fprintf(fid, '%.5g,%.5g', regions(i).coord(j, 1), regions(i).coord(j, 2));
        if j <regions(i).points
            fprintf(fid, '%s', ' ');
        end
    end
    fprintf(fid, '%s\n', '"');
end
fclose(fid);

% output the length of GaN
d1 = x1;
d2 = x2;
d3 = x3 + x4 + x5 + x6 + x7;
d4 = x8;
d5 = x9;
disp("The length of GaN is:")
disp(['d1 = ' num2str(d1*1e3)])
disp(['d2 = ' num2str(d2*1e3)])
disp(['d3 = ' num2str(d3*1e3)])
disp(['d4 = ' num2str(d4*1e3)])
disp(['d5 = ' num2str(d5*1e3)])