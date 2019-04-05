% EEG-ECG Analysis Program
% Author: Gwonhyu Jin, DGIST (overclocked@dgist.ac.kr)
% Date: 2019-01-24
% Final modification date: 2019-03-30
clear

% Start of parameter setting
% Name of *.xlsx file to save analysis result
output_file = 'Result.xlsx';

% If data acquisition setting is changed, please change parameters here. 
number_of_scene = 9;
sampling_rate = 1000;

% Video scene time Information
% If you have other video as stimulus, you should modify this part.
% 10s: Fixation cross start,    16s: Fixation cross end
% 19s: Neutral scene start,     24s: Neutral scene end
% 28s: Scene 1 start,           66s: Scene 1 end
% 70s: Scene 2 start,           103s: Scene 2 end
% 108s: Scene 3 start,          118s: Scene 3 end
% 16s: Black screen 1 start     19s: Black screen 1 end
% 24s: Black screen 2 start     28s: Black screen 2 end
% 66s: Black screen 3 start     70s: Black screen 3 end
% 103s: Black screen 4 start    108s: Black screen 4 end
time_info = [10 16 19 24 28 66 70 103 108 118 ...
    16 19 24 28 66 70 103 108];

% Resolution for heatmap analysis
time_interval = 250;        % 250ms, Time interval for heatmap analysis
time_frame_start = (10001:250:117751);
time_frame_end = (10250:250:118000);
number_of_time_frame = 108*4;
number_of_freq_frame = 90*2+1;
frequency_interval = 0.5;   % Frequency resolution for heatmap analysis

% Data index information
channel_eeg_1 = 1;
channel_eeg_2 = 2;
channel_ecg = 3;

% Frequency setting
freq_begin = 0;
freq_end = 90;

% End of paratmeter setting

number_of_data = input('Number of data files: ');

% Initialize matrix to store analysis result
heart_rate_minmax = zeros(number_of_data, number_of_scene);
heart_rate_std = zeros(number_of_data, number_of_scene);

relative_power_value_1 = zeros(number_of_data, 5, number_of_scene+3);
relative_power_value_2 = zeros(number_of_data, 5, number_of_scene+3);

heatmap_1 = zeros(number_of_time_frame, number_of_freq_frame);
heatmap_2 = zeros(number_of_time_frame, number_of_freq_frame);

mse_entire_1 = zeros(number_of_data, 5);
mse_entire_2 = zeros(number_of_data, 5);
mse_fixation_cross_1 = zeros(number_of_data, 5);
mse_fixation_cross_2 = zeros(number_of_data, 5);
mse_neutral_1 = zeros(number_of_data, 5);
mse_neutral_2 = zeros(number_of_data, 5);
mse_scene1_1 = zeros(number_of_data, 5);
mse_scene1_2 = zeros(number_of_data, 5);
mse_scene2_1 = zeros(number_of_data, 5);
mse_scene2_2 = zeros(number_of_data, 5);
mse_scene3_1 = zeros(number_of_data, 5);
mse_scene3_2 = zeros(number_of_data, 5);
mse_joined_1 = zeros(number_of_data, 5);
mse_joined_2 = zeros(number_of_data, 5);

% Analysis part
for i = 1 : number_of_data
    finished = true;
    while finished
        % Using try-catch for convinience.
        % If you want more detailed troubleshooting, 
        % please erase try-catch structure.
        try
            data_file = input('Name of data file: ', 's');
            load(data_file);
            start_time = input('Start time of video: ');

            t_index = start_time + time_info;
            
            % Calculate heart rate
            is_reversed = false;
            [heart_rate_minmax(i, :), heart_rate_std(i, :)] = ...
                calc_heart_rate(data, channel_ecg, ...
                t_index, is_reversed, number_of_scene, sampling_rate);
            temp = input('1 for normal ecg, 2 for reversed ecg : ');
            if temp == 2
                is_reversed = true;
            end
            
            if is_reversed == true
                [heart_rate_minmax(i, :), heart_rate_std(i, :)] = ...
                    calc_heart_rate(data, channel_ecg, ...
                    t_index, is_reversed, number_of_scene, sampling_rate);
            end

            % Calculate power value
            [relative_power_value_1(i, :, :), relative_power_value_2(i, :, :)] = ...
                calc_relative_power_value(data, ...
                channel_eeg_1, channel_eeg_2, sampling_rate, t_index, ...
                number_of_scene);

            % Calculate mean square error & heatmap data
            % 10s: Video start, 118s : Video end
            % Information part should be excluded
            % e.g. displaying "Start of video"
            t_s = start_time * sampling_rate;
            t_index_start = t_s + time_frame_start;
            t_index_end = t_s + time_frame_end;

            [power_1_result, power_2_result, freq] = ...
                generate_heatmap_data(data, sampling_rate, ...
                freq_begin, freq_end, ...
                t_index_start, t_index_end, ...
                channel_eeg_1, channel_eeg_2, ...
                number_of_time_frame, number_of_freq_frame);

            heatmap_1 = heatmap_1 + power_1_result;
            heatmap_2 = heatmap_2 + power_2_result;

            [mse_entire_1(i,:), mse_entire_2(i,:)] = ...
                calc_mean_square_error(power_1_result, power_2_result, ...
                freq, time_info(1), time_info(10), false);
            [mse_fixation_cross_1(i,:), mse_fixation_cross_2(i,:)] = ...
                calc_mean_square_error(power_1_result, power_2_result, ...
                freq, time_info(1), time_info(2), false);
            [mse_neutral_1(i,:), mse_neutral_2(i,:)] = ...
                calc_mean_square_error(power_1_result, power_2_result, ...
                freq, time_info(3), time_info(4), false);
            [mse_scene1_1(i,:), mse_scene1_2(i,:)] = ...
                calc_mean_square_error(power_1_result, power_2_result, ...
                freq, time_info(5), time_info(6), false);
            [mse_scene2_1(i,:), mse_scene2_2(i,:)] = ...
                calc_mean_square_error(power_1_result, power_2_result, ...
                freq, time_info(7), time_info(8), false);
            [mse_scene3_1(i,:), mse_scene3_2(i,:)] = ...
                calc_mean_square_error(power_1_result, power_2_result, ...
                freq, time_info(9), time_info(10), false);
            [mse_joined_1(i,:), mse_joined_2(i,:)] = ...
                calc_mean_square_error(power_1_result, power_2_result, ...
                freq, time_info(1), time_info(10), true);
            
            finished = false;
        catch
            disp('Error!')
        end
    end
end

% Generate heatmap data
heatmap_1 = heatmap_1 ./ number_of_data;
heatmap_2 = heatmap_2 ./ number_of_data;

% Save result in Result.xlsx
% If you want to change save format,
% please modify this part

disp('Saving Analysis Results (participants order is same as you typed)')
% disp('Min-Max of Heart Rate');
% disp(heart_rate_minmax);
xlswrite(output_file, heart_rate_minmax, 1);

% disp('Standard Deviation of Heart Rate');
% disp(heart_rate_std);
xlswrite(output_file, heart_rate_std, 2);

% disp('Relative Power Value');
for i = 1:12
%     disp(relative_power_value_1(:,:,i));
%     disp(relative_power_value_2(:,:,i));
    xlswrite(output_file, relative_power_value_1(:,:,i), 1+2*i);
    xlswrite(output_file, relative_power_value_2(:,:,i), 2+2*i);
end

% disp('Mean Square Error');
% disp(mse_entire_1);
% disp(mse_entire_2);
% disp(mse_fixation_cross_1);
% disp(mse_fixation_cross_2);
% disp(mse_neutral_1);
% disp(mse_neutral_2);
% disp(mse_scene1_1);
% disp(mse_scene1_2);
% disp(mse_scene2_1);
% disp(mse_scene2_2);
% disp(mse_scene3_1);
% disp(mse_scene3_2);
% disp(mse_joined_1);
% disp(mse_joined_2);
xlswrite(output_file, mse_entire_1, 27);
xlswrite(output_file, mse_entire_2, 28);
xlswrite(output_file, mse_fixation_cross_1, 29);
xlswrite(output_file, mse_fixation_cross_2, 30);
xlswrite(output_file, mse_neutral_1, 31);
xlswrite(output_file, mse_neutral_2, 32);
xlswrite(output_file, mse_scene1_1, 33);
xlswrite(output_file, mse_scene1_2, 34);
xlswrite(output_file, mse_scene2_1, 35);
xlswrite(output_file, mse_scene2_2, 36);
xlswrite(output_file, mse_scene3_1, 37);
xlswrite(output_file, mse_scene3_2, 38);
xlswrite(output_file, mse_joined_1, 39);
xlswrite(output_file, mse_joined_2, 40);

% disp('Heatmap');
% disp(heatmap_1);
% disp(heatmap_2);
xlswrite(output_file, heatmap_1, 41);
xlswrite(output_file, heatmap_2, 42);

disp('Saving Analysis Results Finished')

