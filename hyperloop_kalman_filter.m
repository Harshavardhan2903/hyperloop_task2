%forced hyperloop embedded task 2 problem statement 2 - harsha .

%simulating the motion of the hyperloop

% Define time parameters
dt = 0.1; % time step (seconds)
T = 100; % total time (seconds)
time = 0:dt:T;

% Define motion phases
acceleration_phase = 20; % time to accelerate (seconds)
cruising_phase = 60; % time to cruise (seconds)
deceleration_phase = 20; % time to decelerate (seconds)

% Define acceleration and deceleration values
acceleration = 2; % m/s^2
deceleration = -2; % m/s^2

% Initialize velocity and position
velocity = zeros(size(time));
position = zeros(size(time));

for i = 2:length(time)
    if time(i) <= acceleration_phase
        velocity(i) = velocity(i-1) + acceleration * dt;
    elseif time(i) <= acceleration_phase + cruising_phase
        velocity(i) = velocity(i-1);
    else
        velocity(i) = max(0, velocity(i-1) + deceleration * dt);
    end
    position(i) = position(i-1) + velocity(i) * dt;
end

% Plot the true velocity . This graph represents the ideal motion of
% hyperloop
figure;
plot(time, velocity, 'LineWidth', 2);
title('True Velocity of Hyperloop Pod');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
grid on;

% Simulate random noisy sensor outputs 
noise_std = 2; % standard deviation of the noise
noisy_velocity = velocity + noise_std * randn(size(velocity));

% Plot the noisy measurements
figure;
plot(time, noisy_velocity, 'LineWidth', 1.5);
hold on;
plot(time, velocity, 'LineWidth', 2);
title('Noisy Velocity Measurements');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('Noisy Measurements', 'True Velocity');
grid on;

% Kalman Filter implementation
Q = 0.1; % process noise covariance
R = noise_std^2; % measurement noise covariance
x_est = 0; % initial estimated state (velocity)
P = 1; % initial estimation covariance

x_est_arr = zeros(size(time)); % array to store estimated velocities

for i = 2:length(time)
    % Time update (prediction)
    x_pred = x_est; % predicted state
    P_pred = P + Q; % predicted covariance
    
    % Measurement update (correction)
    K = P_pred / (P_pred + R); % Kalman gain
    x_est = x_pred + K * (noisy_velocity(i) - x_pred); % updated state
    P = (1 - K) * P_pred; % updated covariance
    
    % Store the estimated velocity
    x_est_arr(i) = x_est;
end

% Plot the estimated velocity
figure;
plot(time, x_est_arr, 'LineWidth', 2);
hold on;
plot(time, velocity, 'LineWidth', 2);
title('Estimated Velocity using Kalman Filter');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('Estimated Velocity', 'True Velocity');
grid on;

% Adjust the noise parameters
Q = 0.1; % adjusted process noise covariance
R = noise_std^2; % adjusted measurement noise covariance

% Re-run the Kalman Filter with adjusted noise parameters
x_est = 0; % re-initialize estimated state (velocity)
P = 1; % re-initialize estimation covariance
x_est_arr = zeros(size(time)); % re-initialize array to store estimated velocities

for i = 2:length(time)
    % Time update (prediction)
    x_pred = x_est; % predicted state
    P_pred = P + Q; % predicted covariance
    
    % Measurement update (correction)
    K = P_pred / (P_pred + R); % Kalman gain
    x_est = x_pred + K * (noisy_velocity(i) - x_pred); % updated state
    P = (1 - K) * P_pred; % updated covariance
    
    % Store the estimated velocity
    x_est_arr(i) = x_est;
end

% Plot the re-estimated velocity
figure;
plot(time, x_est_arr, 'LineWidth', 2);
hold on;
plot(time, velocity, 'LineWidth', 2);
title('Re-estimated Velocity using Tuned Kalman Filter');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('Re-estimated Velocity', 'True Velocity');
grid on;
