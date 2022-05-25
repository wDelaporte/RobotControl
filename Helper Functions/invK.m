function [t1, t2, t3, t4] = invK(x,y,z)
%inv_K Calculates inverse kinematics of joint angles
%   x,y,z - Coordinates of end effector in task space

%   [theta_1,theta_2,theta_3_final,theta_4] - Vector of motor angles


l1 = 17.2; % height (ground to second joint)
l2 = 20; % length of first limb
l3 = 20; % length of second limb
l4 = 16; % length of grabber

off1 = 0; % Motor 1 offset
off2 = 0; % Motor 1 offset
off3 = 0; % Motor 1 offset
off4 = 0; % Motor 1 offset


t1 = atan(y/x);

R_01 = [cos(t1) -sin(t1) 0;
    sin(t1) cos(t1) 0;
    0 0 1];

p = R_01*[x;y;z];

syms t2 t3;

eqn1 = p(1) == l2*sin(t2) + l3*cos(t3);
eqn2 = p(3) == l1 + l2*cos(t2) - l3*sin(t3) - l4;

[t2, t3] = solve([eqn1, eqn2], [t2, t3]);

for k = 1:length(t2)
    if (t2(k) >= -0.1 && t2(k) < pi/2 - 0.01)
        index = k;
    end
end

t2 = -(eval(t2(index)) + off2); % t2 Inverted for motor orientaton
t3 = eval(t3(index)) + off3;
t4 = -(t3 - off3 + off4); % t4 Inverted for motor orientation
t1 = t1 + off1;
end

