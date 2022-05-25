function [angles_detail] = speedcontrol(track_position)

    angles = [];
    for i = 1:length(track_position(:,1))  
        [h_theta1, h_theta2, h_theta3, h_theta4] = inv_K2(track_position(i,1), track_position(i,2), track_position(i,3));
        
        offset2 = pi/2 - (1.7);
        h_theta2 = h_theta2 - offset2;
        h_theta2_increase = pi/2 - h_theta2;
        h_theta3 = -pi + abs(h_theta3) + h_theta2_increase + 0.05;
        h_theta4 = -h_theta3;
        
%         [trac1,trac2,trac3,trac4] = trac(h_theta1, h_theta2, h_theta3, h_theta4,s,numID);

        
        
        angles(i,:) = [h_theta1, h_theta2, h_theta3, h_theta4];
    end
    
    angles_detail = [];
    for i = 1:length(angles(:,1))-1
        step_number1 = int8(abs(angles(i,1)- angles(i+1,1))/0.005);
        step_number2 = int8(abs(angles(i,2)- angles(i+1,2))/0.005);
        step_number3 = int8(abs(angles(i,3)- angles(i+1,3))/0.005);
        step_number4 = int8(abs(angles(i,4)- angles(i+1,4))/0.005);
        step_number = max([step_number1,step_number2,step_number3,step_number4]);
%         step_number = 20;
        if angles(i,1) ~= angles(i+1,1) || angles(i,2) ~= angles(i+1,2) || angles(i,3) ~= angles(i+1,3) || angles(i,4) ~= angles(i+1,4)
            angles_detail = [angles_detail;[linspace(angles(i,1),angles(i+1,1),step_number)',...
                             linspace(angles(i,2),angles(i+1,2),step_number)',...
                             linspace(angles(i,3),angles(i+1,3),step_number)',...
                             linspace(angles(i,4),angles(i+1,4),step_number)']];
        else 
            angles_detail = [angles_detail;angles(i,:)];
        end
    end
end