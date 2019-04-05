function [output_1, output_2] = calc_mean_square_error( ...
    power_value_1, power_value_2, freq, t_begin, t_end, ...
    join)
% calc_mean_square_error    Calculate mean square error for EEG data
%  Parameters
%       power_value_1       Normalized power spectrum for channel 1
%       power_value_2       Normalized power spectrum for channel 2
%       freq                Frequency information of power spectrum
%       t_begin             Start time of scenes
%       t_end               End time of scenes
%       join                If true, calculate after concatenate scene 1, 2, 3 data
%  Returns
%       output_1            Mean square error for EEG data (channel 1)
%       output_2            Mean square error for EEG data (channel 2)

	% Initialization
    clear power_1_int power_2_int;
    output_1 = zeros(1, 5);
    output_2 = zeros(1, 5);
    t_begin = t_begin - 10;
    t_end = t_end - 10;
   
   	% If you use other experiment settings and other video stimulus,
	% you should modify these parameters
	% Start parameter setting
    % alpha 8 ~ 13, beta 13 ~ 30, theta 4 ~ 8, delta 0.5 ~ 4, gamma 30 ~ 90
    freq_begin = 1 + [1,8,16,26,60];	% 0.5, 4, 8, 13, 30
    freq_end = 1 + [8,16,26,60,180];	% 4, 8, 13, 30, 90
    
    t_begin = t_begin * 4 + 1;		% Time resolution : 250ms
    t_end = t_end * 4;
   
    start_stimulus = [28, 70, 108] - 10;
    end_stimulus = [66, 103, 118] - 10;
    % End parameter setting
    
    % Concatenate data in case of join is true
    if join == true
        % 10s : Base Start, 16s : Base end
        % 19s : L29 Start, 24s : L29 end
        % 28s : Bus Start, 66s : Bus end
        % 70s : Kakao Start, 103s : Kakao end
        % 108s : Noise Start, 118s : Noise end        
        t_begin = 1+4.*start_stimulus;
        t_end = 4.*end_stimulus;
        power_value_1 = [power_value_1(t_begin(1):t_end(1),:); ...
            power_value_1(t_begin(2):t_end(2),:); ...
            power_value_1(t_begin(3):t_end(3),:)];
        power_value_2 = [power_value_2(t_begin(1):t_end(1),:); ...
            power_value_2(t_begin(2):t_end(2),:); ...
            power_value_2(t_begin(3):t_end(3),:)];
    end
	% End parameter setting

    % Calculate area
    for i = 1:5
        temp_1(:, i) = trapz(freq(freq_begin(i):freq_end(i)), ...
            transpose(power_value_1(:, freq_begin(i):freq_end(i))));
        temp_2(:, i) = trapz(freq(freq_begin(i):freq_end(i)), ...
            transpose(power_value_2(:, freq_begin(i):freq_end(i))));

        result_1(:, i) = transpose(temp_1(:, i));
        result_2(:, i) = transpose(temp_2(:, i));
    end
    
	% Calculate mean square error for each EEG frequency band
    for i = 1:5
        if join == false
            temp1 = result_1(t_begin:t_end, i);
            temp2 = result_2(t_begin:t_end, i);
        else
            temp1 = result_1(:, i);
            temp2 = result_2(:, i);
        end
        
        avg_1 = mean(temp1);
        avg_2 = mean(temp2);

        temp_1 = (temp1 - avg_1) .^ 2;
        temp_2 = (temp2 - avg_2) .^ 2;
        
        mse_1 = sum(temp_1) / size(temp_1, 1);
        mse_2 = sum(temp_2) / size(temp_2, 1);

        output_1(i) = mse_1;
        output_2(i) = mse_2;
    end
end
