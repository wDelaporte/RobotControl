function [x,y,z] = coord_generator(letter, number)
%coord_generator Returns the x-y coordinate corresponding to a chess board square
%   letter - char The column letter of the board square
%   number - int The row number of the board square
%
%   [x,y,z] - int Vector of task-space coordinates for the center of square
%
%   Invalid inputs produce -1 for the corresponding coordinate and print a
%   message to console

squareSide = 3; % Side length of a single board square
border = 2; % Width of board border
offset = 10; % Distance between robot and board
centre = 'e'; % Centre of robot in line with leading edge of this column
boardHeight = 0; % Height of the board

if number > 8 || number < 1
    disp("Invalid number, must be between 1 and 8")
    x = -1;
else 
    x = offset + border + squareSide*(number - 0.5);
end

if letter < 'a' || letter > 'l'
    disp("Invalid letter, must be lowercase and between 'a' and 'l'")
    y = -1;
else
    y = squareSide * (letter - centre + 0.5);
end

z = boardHeight;

end