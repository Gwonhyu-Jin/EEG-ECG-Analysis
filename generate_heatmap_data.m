function [result_1, result_2, freq] = generate_heatmap_data(data, ...
    sampling_rate, min_frq, max_frq, t_start, t_end, ...
    channel_1, channel_2, number_of_time_frame, number_of_freq_frame)
% generate_heatmap_data         Generate heatmap data for one person
%                   (cf. Average value will be calculated in analysis.m)
%  Parameters
%       data                    Raw data
%       sampling_rate           Sampling rate of equipment
%       min_frq         		Minimum value of EEG frequency bands range
%       max_frq					Maximum value of EEG frequency bands range
%       t_start                 The moment that video was started	
%       t_end                   The moment that video was ended
%       channel_1               Index for channel 1 data
%       channel_2               Index for channel 2 data
%       number_of_time_frame    Num
%       number_of_freq_frame    Num
%  Returns
%       result_1                Heatmap data of EEG data (channel 1)
%       result_2                Heatmap data of EEG data (channel 2)
%       freq					Frequency information for power spectrum	
    clear power_1_int power_2_int;

%     number_of_time_frame = 108*4;
%     number_of_freq_frame = 181;
    
    result_1 = zeros(number_of_time_frame, number_of_freq_frame);
    result_2 = zeros(number_of_time_frame, number_of_freq_frame);

    for t = 1:number_of_time_frame
        i_s = t_start(t);
        i_f = t_end(t);

        x_1 = data(i_s:i_f, channel_1); % gamma_1
        x_2 = data(i_s:i_f, channel_2); % gamma_2
        
        [temp1, temp2, freq] = power_spectrum(x_1, x_2, sampling_rate, ...
            min_frq, max_frq, 0);

        result_1(t, :) = temp1 ./ trapz(freq, temp1);
        result_2(t, :) = temp2 ./ trapz(freq, temp2);
    end
end
