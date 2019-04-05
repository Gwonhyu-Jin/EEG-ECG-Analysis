function [result_1, result_2, freq] = ...
    power_spectrum(x_1, x_2, sampling_rate, min_frq, max_frq, n)
% power_spectrum        Calculate power spectrum of two EEG data
%  Parameters
%       x1              EEG data (Channel 1) 
%       x2              EEG data (Channel 2)
%       sampling_rate   Sampling rate of equipment 
%       min_frq         Minimum value of EEG frequency bands range
%       max_frq         Maximum value of EEG frequency bands range
%  Returns
%       result_1        Power spectrum of channel 1 data
%       reulst_2        Power spectrum of channel 2 data
%       freq            Frequency information about power spectrum
    
    y1 = fft(x_1, n);       % DFT
    y2 = fft(x_2, n);

    f = (0:n-1)*(sampling_rate/n);    % Frequency range

    power_1 = y1.*conj(y1)/n;  % Power of the DFT
    power_2 = y2.*conj(y2)/n;  % Power of the DFT
    
    [result_1, result_2, freq] = ...
        select_freq(power_1, power_2, f, min_frq, max_frq);
end
