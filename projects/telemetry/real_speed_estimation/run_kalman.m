function kalman_state = run_kalman(sensor_reading, T, dt, R, Q)

%   Run the Kalman filter for existing sensor readings over a known timespan
% 
%   Args:
%       sensor_reading: An nx3 matrix where n is the number of timestamps,
%           representing the measured acceleration, velocity, and position
%       T: A 1xn vector, representing the timestamps
%       dt: A float representing the timestep
%       R: A 3x3 matrix representing the measurement noise covariance
%       Q: A 3x3 matrix representing the initial process noise covariance
% 
%   Returns:
%       kalman_stateAn nx3 matrix representing the Kalman estimated
%       acceleration, velocity, and position

    state = sensor_reading(1,:)';
    p_cov = Q;
    
    kalman_state = zeros(length(T), 3);
    kalman_state(1,:) = state;
    
    for i=2:length(T)
        measurement = sensor_reading(i,:)';
        [state, p_cov] = kalman_update(state, p_cov, measurement, dt, R, Q);
        kalman_state(i,:) = state';
    end
end