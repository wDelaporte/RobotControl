function [pos_traj, vel_traj] = trajectory2(initial,initial_dot,final,final_dot)
%trajectory Generates a trajectory between 2 point 
%   initial     - 1x3 Coordinate vector of initial position
%   initial_dot - 1x3 Initial velocity vector
%   final       - 1x3 Coordinate vector of final position
%   final_dot   - 1x3 Final velocity vector
%
%   pos_tra     - Nx3 Matrix of positions in the trajectory
%   vel_traj    - Nx3 Matrix of velocities in the trajectory

%% Create local variables for initial and final points
xi = initial(1);
yi = initial(2);
zi = initial(3);
xi_dot = initial_dot(1);
yi_dot = initial_dot(2);
zi_dot = initial_dot(3);
xf = final(1);
yf = final(2);
zf = final(3);
xf_dot = final_dot(1);
yf_dot = final_dot(2);
zf_dot = final_dot(3);

%% Assign via points
overpass = 8; % The height needed to move over top of pieces on the board

x2 = xi;
y2 = yi;
if zi > overpass
    z2 = zi;
else
    z2 = overpass;
end

x3 = xf;
y3 = yf;
if zf > overpass
    z3 = zf;
else
    z3 = overpass;
end

%% Create local variables for via-point speeds
x2_dot = 0;
y2_dot = 0;
z2_dot = 0;

x3_dot = 0;
y3_dot = 0;
z3_dot = 0;

%% Solve for polynomial coefficients
syms ax_0 ax_1 ax_2 ax_3 ay_0 ay_1 ay_2 ay_3 az_0 az_1 az_2 az_3 % Initial to via 1
syms bx_0 bx_1 bx_2 bx_3 by_0 by_1 by_2 by_3 bz_0 bz_1 bz_2 bz_3 % Via 1 to via 2
syms cx_0 cx_1 cx_2 cx_3 cy_0 cy_1 cy_2 cy_3 cz_0 cz_1 cz_2 cz_3 % Via 2 to final

syms t_f % Time at end of trajectory segment

t0 = 0; % Time at initial pos
t1 = 0.5; % Time at via point 1
t2 = 2.5; % Time at via point 2
t3 = 3; % Time at final pos

coeff_matrix = [1 0 0 0; 1 t_f t_f^2 t_f^3; 0 1 0 0; 0 1 2*t_f 3*t_f^2];
seg_A = subs(coeff_matrix, t_f, t1);
seg_B = subs(coeff_matrix, t_f, t2);
seg_C = subs(coeff_matrix, t_f, t3);

% Segment A - Initial to Via 1
xPoly_A = seg_A * [ax_0; ax_1; ax_2; ax_3] == [xi; x2; xi_dot; x2_dot];
yPoly_A = seg_A * [ay_0; ay_1; ay_2; ay_3] == [yi; y2; yi_dot; y2_dot];
zPoly_A = seg_A * [az_0; az_1; az_2; az_3] == [zi; z2; zi_dot; z2_dot];

ax = solve(xPoly_A,[ax_0 ax_1 ax_2 ax_3]);
ay = solve(yPoly_A,[ay_0 ay_1 ay_2 ay_3]);
az = solve(zPoly_A,[az_0 az_1 az_2 az_3]);
ax = [ax.ax_0 ax.ax_1 ax.ax_2 ax.ax_3];
ay = [ay.ay_0 ay.ay_1 ay.ay_2 ay.ay_3];
az = [az.az_0 az.az_1 az.az_2 az.az_3];

% Segment B - Via 1 to Via 2
xPoly_B = seg_B * [bx_0; bx_1; bx_2; bx_3] == [x2; x3; x2_dot; x3_dot];
yPoly_B = seg_B * [by_0; by_1; by_2; by_3] == [y2; y3; y2_dot; y3_dot];
zPoly_B = seg_B * [bz_0; bz_1; bz_2; bz_3] == [z2; z3; z2_dot; z3_dot];

bx = solve(xPoly_B,[bx_0 bx_1 bx_2 bx_3]);
by = solve(yPoly_B,[by_0 by_1 by_2 by_3]);
bz = solve(zPoly_B,[bz_0 bz_1 bz_2 bz_3]);
bx = [bx.bx_0 bx.bx_1 bx.bx_2 bx.bx_3];
by = [by.by_0 by.by_1 by.by_2 by.by_3];
bz = [bz.bz_0 bz.bz_1 bz.bz_2 bz.bz_3];

% Segment C - Via 2 to Final
xPoly_C = seg_C * [cx_0; cx_1; cx_2; cx_3] == [x3; xf; x3_dot; xf_dot];
yPoly_C = seg_C * [cy_0; cy_1; cy_2; cy_3] == [y3; yf; y3_dot; yf_dot];
zPoly_C = seg_C * [cz_0; cz_1; cz_2; cz_3] == [z3; zf; z3_dot; zf_dot];

cx = solve(xPoly_C,[cx_0 cx_1 cx_2 cx_3]);
cy = solve(yPoly_C,[cy_0 cy_1 cy_2 cy_3]);
cz = solve(zPoly_C,[cz_0 cz_1 cz_2 cz_3]);
cx = [cx.cx_0 cx.cx_1 cx.cx_2 cx.cx_3];
cy = [cy.cy_0 cy.cy_1 cy.cy_2 cy.cy_3];
cz = [cz.cz_0 cz.cz_1 cz.cz_2 cz.cz_3];

%% Generate trajectories
% Create time steps
time = t0:0.45:t3;

% Pre-allocate vector sizes
x_pos = zeros(length(time), 1);
y_pos = zeros(length(time), 1);
z_pos = zeros(length(time), 1);

x_vel = zeros(length(time), 1);
y_vel = zeros(length(time), 1);
z_vel = zeros(length(time), 1);

% Iterate through vectors
for i = 1:length(time)
    if time(i) < t1
        % Segment A
        x_pos(i) = ax * [1; time(i); time(i)^2; time(i)^3];
        y_pos(i) = ay * [1; time(i); time(i)^2; time(i)^3];
        z_pos(i) = az * [1; time(i); time(i)^2; time(i)^3];
        
        x_vel(i) = ax * [0; 1; 2*time(i); 3*time(i)^2];
        y_vel(i) = ay * [0; 1; 2*time(i); 3*time(i)^2];
        z_vel(i) = az * [0; 1; 2*time(i); 3*time(i)^2];
    elseif time(i) < t2
        % Segment B
        x_pos(i) = bx * [1; time(i); time(i)^2; time(i)^3];
        y_pos(i) = by * [1; time(i); time(i)^2; time(i)^3];
        z_pos(i) = bz * [1; time(i); time(i)^2; time(i)^3];
        
        x_vel(i) = bx * [0; 1; 2*time(i); 3*time(i)^2];
        y_vel(i) = by * [0; 1; 2*time(i); 3*time(i)^2];
        z_vel(i) = bz * [0; 1; 2*time(i); 3*time(i)^2];
    else 
        % Segment C
        x_pos(i) = cx * [1; time(i); time(i)^2; time(i)^3];
        y_pos(i) = cy * [1; time(i); time(i)^2; time(i)^3];
        z_pos(i) = cz * [1; time(i); time(i)^2; time(i)^3];
        
        x_vel(i) = cx * [0; 1; 2*time(i); 3*time(i)^2];
        y_vel(i) = cy * [0; 1; 2*time(i); 3*time(i)^2];
        z_vel(i) = cz * [0; 1; 2*time(i); 3*time(i)^2];
    end
end

pos_traj = [x_pos, y_pos, z_pos];
vel_traj = [x_vel, y_vel, z_vel];
end

