function [result_1, result_2] ...
        = calc_relative_power_value(data, channel_1, channel_2, ...
        sampling_rate, t_index, number_of_scene)
% calc_relative_power_value     Calculate relative power value of EEG data
%  Parameters
%       data                    EEG data
%       channel_1               Index of EEG channel 1 data 
%       channel_2               Index for EEG channel 2 data
%       sampling_rate           Sampling rate of equipment
%       t_index                 Time information for scenes
%       number_of_scene     Number of scene in video clip
%  Results
%       relative_1              Relative power value for Channel 1 data
%       relative_2              Relative power value for Channel 2 data

    % Constant initialization
    % If you change experiment settings (video stimulus, etc...)
    % Please modify this part
    type_of_results = 12;
    type_of_brain_wave = 5;
    number_of_scenes = 9;
    
    % Frequency range
    alpha_start = 8;
    alpha_end = 13;
    beta_start = 13;
    beta_end = 30;
    gamma_start = 30;
    gamma_end = 90;
    theta_start = 4;
    theta_end = 8;
    delta_start = 0.5;
    delta_end = 4;
    
    fixation_cross = 1;
    scenes = [3, 4, 5];
    black_screens = [6, 7, 8, 9];
    
    % If number of stimulus scene and black screen changed,
    % please modify code in below, 
    % calculating baseline and average value part
    number_of_stimulus_scene = 3;
    number_of_black_screen = 4;
    % End of constant initizliation

    % Initialization
    raw_1 = zeros(type_of_brain_wave, type_of_results);
    raw_2 = zeros(type_of_brain_wave, type_of_results);

    result_1 = zeros(type_of_brain_wave, type_of_results);
    result_2 = zeros(type_of_brain_wave, type_of_results);

    sum_1 = zeros(1, type_of_results);
    sum_2 = zeros(1, type_of_results);
    
    % Calculate Area of Power Spectrum
    [raw_1(1,1:number_of_scenes), raw_2(1,1:number_of_scenes)] ...
        = calc_power_value(data, sampling_rate, alpha_start, alpha_end, ...
        t_index, channel_1, channel_2, number_of_scene); % alpha
    [raw_1(2,1:number_of_scenes), raw_2(2,1:number_of_scenes)] ...
        = calc_power_value(data, sampling_rate, beta_start, beta_end, ...
        t_index, channel_1, channel_2, number_of_scene); % beta
    [raw_1(3,1:number_of_scenes), raw_2(3,1:number_of_scenes)] ...
        = calc_power_value(data, sampling_rate, gamma_start, gamma_end, ...
        t_index, channel_1, channel_2, number_of_scene); % gamma
    [raw_1(4,1:number_of_scenes), raw_2(4,1:number_of_scenes)] ...
        = calc_power_value(data, sampling_rate, theta_start, theta_end, ...
        t_index, channel_1, channel_2, number_of_scene); % theta
    [raw_1(5,1:number_of_scenes), raw_2(5,1:number_of_scenes)] ...
        = calc_power_value(data, sampling_rate, delta_start, delta_end, ...
        t_index, channel_1, channel_2, number_of_scene); % delta

    % Calculate Sum of Each Area of Power Spectrum
    for i = 1:type_of_brain_wave
        sum_1 = sum_1 + raw_1(i,:);
        sum_2 = sum_2 + raw_2(i,:);
    end

    % Calculate Relative Power Spectral Density
    for i = 1:type_of_brain_wave
        result_1(i,:) = raw_1(i,:) ./ sum_1;
        result_2(i,:) = raw_2(i,:) ./ sum_2;
    end

    % Calculate baseline and average value of scenes
    % If number of stimulus scenes and black screen modified,
    % please modify this part
    for i = 1:type_of_brain_wave
        result_1(i,number_of_scenes+1) = ...
            (result_1(i,scenes(1))+result_1(i,scenes(2))+ ...
            result_1(i,scenes(3))) ./ number_of_stimulus_scene;
        result_2(i,number_of_scenes+1) = ...
            (result_2(i,scenes(1))+result_2(i,scenes(2))+ ...
            result_2(i,scenes(3))) ./ number_of_stimulus_scene;
        result_1(i,number_of_scenes+2) = ...
            (result_1(i,fixation_cross)+result_1(i,black_screens(1))+ ...
            result_1(i,black_screens(2))+result_1(i,black_screens(3))+ ...
            result_1(i,black_screens(4))) ./ (number_of_black_screen + 1);
        result_2(i,number_of_scenes+2) = ...
            (result_2(i,fixation_cross)+result_2(i,black_screens(1))+ ...
            result_2(i,black_screens(2))+result_2(i,black_screens(3))+ ...
            result_2(i,black_screens(4))) ./ (number_of_black_screen + 1);
        result_1(i,number_of_scenes+3) = ...
            (result_1(i,black_screens(1))+result_1(i,black_screens(2))+ ...
            result_1(i,black_screens(3))+result_1(i,black_screens(4))) ...
            ./ (number_of_black_screen);
        result_2(i,number_of_scenes+3) = ...
            (result_2(i,black_screens(1))+result_2(i,black_screens(2))+ ...
            result_2(i,black_screens(3))+result_2(i,black_screens(4))) ...
            ./ (number_of_black_screen);
    end
end

