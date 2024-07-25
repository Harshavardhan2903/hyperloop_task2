% Parameters
numMagnets = 8;
theta = linspace(0, 2*pi, numMagnets + 1);
theta(end) = []; % Remove the duplicate point at 2*pi

% Define the magnetization directions in degrees
magDirections = [0, 45, 90, 135, 180, 225, 270, 315];

% Plot the circular Halbach array
figure;
hold on;
for k = 1:numMagnets
    % Position of each magnet
    x = cos(theta(k));
    y = sin(theta(k));
    
    % Magnetization vector
    angle = deg2rad(magDirections(k));
    u = cos(angle);
    v = sin(angle);
    
    % Plot the magnet position and direction
    plot(x, y, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
    quiver(x, y, u, v, 0.5, 'r', 'LineWidth', 2, 'MaxHeadSize', 2);
end

% Add labels and title
xlabel('X');
ylabel('Y');
title('Circular Halbach Array with 8 N54 Magnets');
axis equal;
grid on;
hold off;
