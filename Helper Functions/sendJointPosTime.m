
% sendJointPos.m
% --------------------------
% Licenting Information: You are free to use or extend this project
% for educational purposes provided that (1) you do not distribute or
% publish solutions, (2) you retain this notice, and (3) you provide 
% clear attribution to the University of Melbourne, Department of 
% Mechanical Engineering.
% 
% Attribution Information: The ChessBot project was developed at the
% University of Melbourne. The core project was primarily developed
% by Professor Denny Oetomo (doetomo@unimelb.edu.au). The ChessBot 
% Skeleton Code was developed by Nathan Batham 
% (nathan.batham@unimelb.edu.au)


function sendJointPosTime(s, jointPos, numMotors, dt)
    
    % Send joint velocities to Arduino over serial. This is done by
    % first converting the floats to a string and then adding a
    % terminating non-numeric string character.
    
    % External Variables
    % @ s                   - Serial object.
    % @ jointPos            - Vector of joint velocites to be sent
    %                   to each motor in rad/s.
    % @ dt                  - Time between each trajectory point
    
    
    % Send drive motor command
    fprintf(s, '%s', 'hpt\n');
    fprintf(s, '%s', 'hpt\n');

    % Send joint velocities individually
    for i=1:numMotors
        fprintf(s, '%s', num2str(jointPos(i), '%.5f') + "e");
    end

    % Wait for arduino ack
    while ( fread(s, 1, 'uchar') ~= 'd' ) 
    end
    
    % Send dt to Arduino
    fprintf(s, '%s', num2str(dt, '%.5f') + "e");

    % Wait for arduino ack
    while ( fread(s, 1, 'uchar') ~= 'f' ) 
    end

end
