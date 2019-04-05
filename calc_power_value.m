function [power_value_1, power_value_2] = calc_power_value(data, ...
    sampling_rate, min_frq, max_frq, t_index, channel_1, channel_2)
% calc_power_value          Calculate power value for EEG data
%  Parameters
%       data                EEG data
%       sampling_rate       Sampling rate of equipment
%       min_frq             Minimum value for frequency band
%       max_frq             Maximum value for frequency band
%       t_index             Start and end time information for scenes
%       channel_1           Index for EEG channel 1 data
%       channel_2           Index for EEG channel 2 data
%  Returns
%       power_value_1       Power value for EEG data (channel 1)
%       power_value_2       Power value for EEG data (channel 2)
    clear power_value_1 power_value_2;

	% Initialization
    number_of_frame = 9;
    power_value_1 = zeros(number_of_frame, 1);
    power_value_2 = zeros(number_of_frame, 1);

    for t = 1:number_of_frame
		% Get time index
        i_s = int32(t_index(2*t - 1) * 1000);
        i_f = int32(t_index(2*t) * 1000);

		% Calculate power value
        x1 = data(i_s:i_f, channel_1); % gamma_1
        x2 = data(i_s:i_f, channel_2); % gamma_2

        m = length(x1);        % Window length
        n = pow2(nextpow2(m)); % Transform length for optimization

        [power_1_tmp, power_2_tmp, freq] = ...
            power_spectrum(x1, x2, sampling_rate, min_frq, max_frq, n);
        
        power_value_1(t) = trapz(freq, power_1_tmp);
        power_value_2(t) = trapz(freq, power_2_tmp);
    end
end
