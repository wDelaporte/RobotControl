function [trac1,trac2,trac3,trac4] = trac(h_theta1, h_theta2, h_theta3, h_theta4, s, numID, ID)

[motorFB, eFB] = readFB(s, numID, ID);
t1 = motorFB(1);
t2 = motorFB(2);
t3 = motorFB(3);
t4 = motorFB(4);



if (t1 < h_theta1)
    trac1 = t1:0.006:h_theta1;
else 
    trac1 = t1:-0.006:h_theta1;
end

if (t2 < h_theta2)
    trac2 = t2:0.006:h_theta2;
else 
    trac2 = t2:-0.006:h_theta2;
end

if (t3 < h_theta3)
    trac3 = t3:0.006:h_theta3;
else 
    trac3 = t3:-0.006:h_theta3;
end

if (t4 < h_theta4)
    trac4 = t4:0.006:h_theta4;
else 
    trac4 = t4:-0.006:h_theta4;
end


if max([length(trac1),length(trac2), length(trac3),length(trac4)]) == length(trac1)
    trac2(length(trac2):length(trac1)) = trac2(end);
    trac3(length(trac3):length(trac1)) = trac3(end);
    trac4(length(trac4):length(trac1)) = trac4(end);
elseif max([length(trac1),length(trac2), length(trac3),length(trac4)]) == length(trac2)
    trac1(length(trac1):length(trac2)) = trac1(end);
    trac3(length(trac3):length(trac2)) = trac3(end);
    trac4(length(trac4):length(trac2)) = trac4(end);
elseif max([length(trac1),length(trac2), length(trac3),length(trac4)]) == length(trac3)
    trac1(length(trac1):length(trac3)) = trac1(end);
    trac2(length(trac2):length(trac3)) = trac2(end);
    trac4(length(trac4):length(trac3)) = trac4(end);
elseif max([length(trac1),length(trac2), length(trac3),length(trac4)]) == length(trac4)
    trac1(length(trac1):length(trac4)) = trac1(end);
    trac2(length(trac2):length(trac4)) = trac2(end);
    trac3(length(trac3):length(trac4)) = trac3(end);
end


end