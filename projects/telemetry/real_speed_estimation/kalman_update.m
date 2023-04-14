function [state, p_cov] = kalman_update(state, p_cov, measurement, dt, R, Q)

%   Perform one step of a Kalman Filter, estimating acceleration, velocity,
%   and position based on current sensor data and a predicted state based on
%   past sensor data
% 
%   Args:
%       state: A 3x1 vector representing the previous Kalman estimated
%           acceleration, velocity, and position, repectively
%       p_cov: A 3x3 matrix representing the process noise covariance
%       measurement: A 3x1 vector representing the sensor measurement of
%           acceleration, velocity, and position, repectively
%       dt: A float representing the time step
%       R: A 3x3 matrix representing the measurement noise covariance
%       Q: A 3x3 matrix representing the initial process noise covariance
% 
%   Returns:
%       state: A 3x1 vector representing the predicted acceleration, velocity,
%           and position, repectively
%       p_cov: A 3x3 matrix representing the updated process noise covariance
        
    % state update matrix, performing kinematic functions, increase
    % velocity based on acceleration, move position based on velocity
    % [1 0 0     [a    [a
    %  dt 1 0  *  v  =  v + dt*a
    %  0 1 dt]    p]    p + dt*v]
    A = [1 0 0; dt 1 0; 0 dt 1]; 

    H = eye(3);

    % Kalman Filter mathematic operations
    % https://www.bzarg.com/p/how-a-kalman-filter-works-in-pictures/
    predicted_state = A * state;

    predicted_p_cov = A * p_cov * A' + Q;
    
    kalman_gain = (predicted_p_cov*H') / (H*predicted_p_cov*H' + R);
    
    state = predicted_state + kalman_gain*(measurement - H*state);
    
    p_cov = predicted_p_cov - kalman_gain*H*predicted_p_cov;
end