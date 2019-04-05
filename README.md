# EEG-ECG Analysis Program Instruction

## System requirements

MATLAB & Signal Processing Toolbox™

## Prepare data analysis

This program only deals with \*.mat files.
Before run program to analysis your data, you should check labeling of your data correspond to program's channel information. Additionally, you should be aware of indexing of MATLAB is starting from 1 (not 0).

## Run programs

1. Using MATLAB interpreter, run `analysis.m` file.
2. Enter number of data file to analysis.
3. Enter each data file of name (relative path / absolute path) and starting time of video stimulation in data.
4. Check R-wave detection is done properly using pop-up graph. If analysis is not done properly, you can modify parameters for analysis. (See troubleshooting part)
5. Analysis result will be saved in `./Result.xlsx` files while displaying analysis result.
6. Check data analysis result considering order of sheet, column, and row.

Examples
```Text
>> analysis
Number of data files: 2
Name of data file: Data1.mat
Start time of video: 30
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 450
Enter the rate (used for MinPeakHeight): 0.35
Enter the order of equation:45

order =

    45

Warning: Polynomial is badly conditioned. Add points with distinct X values or reduce the degree of the polynomial.
> In polyfit (line 77)
  In calc_heart_rate (line 39)
  In analysis (line 81)
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 450
Enter the rate (used for MinPeakHeight): 0.35
Enter the order of equation:45

order =

    45

Warning: Polynomial is badly conditioned. Add points with distinct X values or reduce the degree of the polynomial.
> In polyfit (line 77)
  In calc_heart_rate (line 39)
  In analysis (line 81)
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
1 for normal ecg, 2 for reversed ecg : 1
Name of data file: Data2.mat
Start time of video: 35
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 450
Enter the rate (used for MinPeakHeight): 0.35
Enter the order of equation:45

order =

    45

Warning: Polynomial is badly conditioned. Add points with distinct X values or reduce the degree of the polynomial.
> In polyfit (line 77)
  In calc_heart_rate (line 39)
  In analysis (line 81)
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 450
Enter the rate (used for MinPeakHeight): 0.35
Enter the order of equation:45

order =

    45

Warning: Polynomial is badly conditioned. Add points with distinct X values or reduce the degree of the polynomial.
> In polyfit (line 77)
  In calc_heart_rate (line 39)
  In analysis (line 81)
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
Enter the MinPeakDistance (0 for next): 0
1 for normal ecg, 2 for reversed ecg : 1
Saving Analysis Results (participants order is same as you typed)
Saving Analysis Results Finished
```

## Sheet formation for `Result.xlsx`

+ Sheet 1: Difference of heart rate (Max(hr) - Min(hr))
  + Column order: Scenes (Default: Fixation cross - Neutral scene - Scene 1 - Scene 2 - Scene 3 - Black screen 1 - Black screen 2 - Black screen 3 - Black screen 4)
  + Row order: Order of data that you made input
+ Sheet 2: Standard deviation of heart rate  
  + Column order: Scenes (Default: Fixation cross - Neutral scene - Scene 1 - Scene 2 - Scene 3 - Black screen 1 - Black screen 2 - Black screen 3 - Black screen 4)
  + Row order: Order of data that you made input
+ Sheet 3 ~ Sheet 26: Relative power value (Channel 1 for odd number, Channel 2 for even number)  
  + Sheet order: Scenes (Default: Fixation cross - Neutral scene - Scene 1 - Scene 2 - Scene 3 - Black screen 1 - Black screen 2 - Black screen 3 - Black screen 4 - Average value of Scene 1,2,3 - Average value of Fixation cross and Black screen 1,2,3,4 - Average value of Black screen 1,2,3,4
  + Column order: EEG frequency band (Alpha wave(8\~13Hz), Beta wave(13\~30Hz), Gamma wave(30\~90Hz), Theta wave(4\~8Hz), Gamma wave(0.5\~4Hz))
  + Row order: Order of data that you made input
+ Sheet 27 ~ Sheet 40: Mean square error, (Channel 1 for odd number, Channel 2 for even number)  
  + Sheet order: Scenes (Fixation cross - Neutral scene - Scene 1 - Scene 2 - Scene 3 - (Scene 1 + Scene 2 + Scene 3) - Entire)
  + Column order: EEG frequency band (Gamma wave(0.5\~4Hz), Theta wave(4\~8Hz), Alpha wave(8\~13Hz), Beta wave(13\~30Hz), Gamma wave(30\~90Hz))
  + Row order: Order of data that you made input
+ Sheet 41 ~ Sheet 42: Data for heatmap analysis (Sheet 41: Channel 1, Sheet 42: Channel 2)  
  + Column order: Frequency (Default: 0, 0.5, 1, 1.5, ..., 90)
  + Row order: Time (Default: 0.5, 1, 1.5, 2, ..., 108)

## Troubleshooting

If you have a problem for ECG analysis, you should modify parameter manually checking detrended data graph.
+ Order of equation
  + Decide order or equation for detrending. We use method of least squares to calculate trend of data. If data is too turbulent, you can detrend data using higher order of equation.
+ MinPeakHeight
  + Decide minimum value to ignore low-value peak. We use multiplication value between entered rate and maximum value of detrended ECG data as MinPeakHeight.
+ MinPeakDistance
  + Decide minimum distance to ignore peak near to R-wave.  

If you use different video as stimulus or want to analysis in other frequency, you can modify variables for setting in `analysis.m` and `calc_mean_square_error.m`, following comments instruction at the top of the code.

## Related research

+ Im, S., Jeong, J., Jin, G., Yeom, J., Jekal, J., Cho, J. A., ... & Heo, J. (2019). A novel supportive assessment for comprehensive aggression using EEG and ECG. _Neuroscience letters_, 694, 136-142.
+ Im, S. Y., Jeong, J., Jin, G., Yeom, J., Jekal, J., Cho, J. A., ... & Heo, J. (2019). MAOA variants differ in oscillatory EEG & ECG activities in response to aggression-inducing stimuli. _Scientific reports_, 9(1), 2680.
+ Im, S., Jin, G., Jeong, J., Yeom, J., Jekal, J., Lee, S. I., ... & Bae, M. (2018). Gender Differences in Aggression-related Responses on EEG and ECG. _Experimental neurobiology_, 27(6), 526-538.
