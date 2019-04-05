function [result_1, result_2] ...
        = calc_relative_power_value(data, sampling_rate, t_index)    
% calc_relative_power_value     Calculate relative power value of EEG data
%  Parameters
%       data                    EEG data
%       sampling_rate           Sampling rate of equipment
%       t_index                 Time information for scenes
%  Results
%       relative_1              Relative power value for Channel 1 data
%       relative_2              Relative power value for Channel 2 data

    % Initialization
    raw_1 = zeros(5, 12);
    raw_2 = zeros(5, 12);

    result_1 = zeros(5, 12);
    result_2 = zeros(5, 12);

    sum_1 = zeros(1, 12);
    sum_2 = zeros(1, 12);
    
    % Calculate Area of Power Spectrum
    [raw_1(1,1:9), raw_2(1,1:9)] ...
        = calc_power_value(data, sampling_rate, 8, 13, t_index, 1, 2); % alpha
    [raw_1(2,1:9), raw_2(2,1:9)] ...
        = calc_power_value(data, sampling_rate, 13, 30, t_index, 1, 2); % beta
    [raw_1(3,1:9), raw_2(3,1:9)] ...
        = calc_power_value(data, sampling_rate, 30, 90, t_index, 1, 2); % gamma
    [raw_1(4,1:9), raw_2(4,1:9)] ...
        = calc_power_value(data, sampling_rate, 4, 8, t_index, 1, 2); % theta
    [raw_1(5,1:9), raw_2(5,1:9)] ...
        = calc_power_value(data, sampling_rate, 0.5, 4, t_index, 1, 2); % delta

    % Calculate Sum of Each Area of Power Spectrum
    for i = 1:5
        sum_1 = sum_1 + raw_1(i,:);
        sum_2 = sum_2 + raw_2(i,:);
    end

    % Calculate Relative Power Spectral Density
    for i = 1:5
        result_1(i,:) = raw_1(i,:) ./ sum_1;
        result_2(i,:) = raw_2(i,:) ./ sum_2;
    end

    % Calculate Entire Frame   
    for i = 1:5
        result_1(i,10) = ...
            (result_1(i,3)+result_1(i,4)+result_1(i,5)) ./ 3;
        result_2(i,10) = ...
            (result_2(i,3)+result_2(i,4)+result_2(i,5)) ./ 3;
        result_1(i,11) = ...
            (result_1(i,1)+result_1(i,6)+result_1(i,7)+ ...
            result_1(i,8)+result_1(i,9)) ./ 5;
        result_2(i,11) = ...
            (result_2(i,1)+result_2(i,6)+result_2(i,7)+ ...
            result_2(i,8)+result_2(i,9)) ./ 5;
        result_1(i,12) = ...
            (result_1(i,6)+result_1(i,7)+result_1(i,8)+ ...
            result_1(i,9)) ./ 4;
        result_2(i,12) = ...
            (result_2(i,6)+result_2(i,7)+result_2(i,8)+ ...
            result_2(i,9)) ./ 4;
    end
end
