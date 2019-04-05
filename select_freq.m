function [result_1, result_2, freq] = ...
    select_freq(power_1, power_2, freq, min_frq, max_frq)
% select_freq       Extract specified frequency of power spectrum 
%  Parameters
%       power_1     Power spectrum of EEG (channel 1)
%       power_2     Power spectrum of EEG (channel 2)
%       freq        Frequency information of power spectrum
%       min_frq     Minimum value for frequency boundary
%       max_frq     Maximum value for frequency boundary
%  Returns
%       result_1    Extracted EEG data (channel 1)
%       result_2    Extracted EEG data (channel 2)
%       freq        Frequency information for extracted data

    % Find minimum frequency boundary 
    for k = 1:length(freq)
        if freq(k) >= min_frq
            first_index = k;
            break
        end
    end

    % Find maximum frequency boundary
    for k = first_index:length(freq)
        if freq(k) > max_frq
            last_index = k-1;
            break
        end
    end

    % Return extracted EEG data and its frequency information
    freq = freq(first_index:last_index);

    result_1 = power_1(first_index:last_index);
    result_2 = power_2(first_index:last_index);
end
