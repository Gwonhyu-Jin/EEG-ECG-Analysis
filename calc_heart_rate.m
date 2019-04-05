function [hr_diff, hr_std] = calc_heart_rate(data, data_index, ...
    t_index, is_reversed, number_of_scene, sampling_rate)
% calc_heart_rate           Calculate difference and standard deviation of
%                           heart rate from ECG raw data
%  Parameters
%       data                ECG data to analysis
%       data_index          Index of ECG in raw data
%       t_index             Information for time of scenes
%       is_reversed         True if reversed due to bad electrode attachment
%       number_of_scene     Number of scene in video clip
%  Returns
%       hr_diff             Difference of max and min value of heart rate
%       hr_std              Standard deviation of heart rate

	% Initialization
    hr_diff = zeros(number_of_scene, 1);
    hr_std = zeros(number_of_scene, 1);

    for n = 1:number_of_scene
		% Initialize initial paramters
		min_peak_distance = sampling_rate*0.45;
        default_rate = 0.45;
        order = 6;

		% Repeat calculate heart rate until analysis is done properly
        while min_peak_distance
            i_s = int32(t_index(2*n - 1) * sampling_rate);
            i_f = int32(t_index(2*n) * sampling_rate);

            noisyECG_withTrend = data(i_s:i_f, data_index);

            if is_reversed
                noisyECG_withTrend = (-1)*noisyECG_withTrend;
            end

            try
                t = 1:length(noisyECG_withTrend);

                % Detrend ECG data using methods of least squre
                [p,~,mu] = polyfit((1:numel(noisyECG_withTrend))', ...
                    noisyECG_withTrend,order);
                f_y = polyval(p,(1:numel(noisyECG_withTrend))',[],mu);

                ECG_data = noisyECG_withTrend - f_y;
                
                % Detect R-wave using given parameters
                max_value = max(noisyECG_withTrend) * default_rate;
                [~,locs_Rwave_trend] = findpeaks(noisyECG_withTrend,...
                    'MinPeakHeight', max_value, ...
                    'MinPeakDistance',min_peak_distance);
                max_value = max(ECG_data) * default_rate;
                [~,locs_Rwave_detrend] = findpeaks(ECG_data, ...
                    'MinPeakHeight', max_value, ...
                    'MinPeakDistance',min_peak_distance);
                clf();

                % Disploay Original ECG data and its detected R-wave
                subplot(2, 1, 1);
                hold on
                plot(t, noisyECG_withTrend, t, f_y);
                plot(locs_Rwave_trend, ...
                    noisyECG_withTrend(locs_Rwave_trend), ...
                    'rv','MarkerFaceColor','r')
                legend('Original Data', 'Trend', 'R wave', ...
                    'Location', 'southeast');
                xlabel('Samples');
                ylabel('Voltage(mV)');
                title('Data with Trend');

                % Disploay Detrended ECG data and its detected R-wave
                subplot(2, 1, 2);
                hold on
                plot(t, ECG_data);
                plot(locs_Rwave_detrend,ECG_data(locs_Rwave_detrend), ...
                    'rv','MarkerFaceColor','r')
                legend('Detrended Data', 'R wave', 'Location', 'southeast');
                xlabel('Samples');
                ylabel('Voltage(mV)');
                title('Detrended Data');

                bpm = 60000 ./ diff(locs_Rwave_detrend);
                hr_diff(n) = max(bpm) - min(bpm);

                hr_std(n) = std(bpm);

				% Check ECG data graph and modify parameters if analysis is not done properly
                min_peak_distance = ...
                    input('Enter the MinPeakDistance (0 for next): ');
                if min_peak_distance
                    default_rate = input('Enter the rate (used for MinPeakHeight): ');
                    order = input('Enter the order of equation:');
                end
            catch
                disp('Invalid file. Assign NaN (Not a Number)');
                hr_diff(n) = NaN;
                hr_std(n) = NaN;

                min_peak_distance = 0;
                default_rate = 0.45;
            end
        end
    end
end
