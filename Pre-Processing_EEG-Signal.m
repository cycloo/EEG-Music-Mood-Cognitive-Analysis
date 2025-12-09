%% Pre-Processing EEG Signal
% Read EEG data from TXT file
eegData = readmatrix('G2.4.2_EEG.txt');   % Change path if needed
fp1Signal = eegData(:, 1);                % EEG data from FP1 electrode

% Parameters
Fs = 42000;            % Sampling frequency (Hz)
fchp = 1;              % High-pass cutoff (Hz)
fclp = 40;             % Low-pass cutoff (Hz)
fcn = [49 51];         % Notch filter range to remove 50 Hz power-line noise

%% Filter Design
% High-pass filter
[bhp, ahp] = butter(1, fchp / (Fs/2), 'high');

% Low-pass filter
[blp, alp] = butter(3, fclp / (Fs/2), 'low');

% Notch filter
centerFreq = (fcn(1) + fcn(2)) / 2;
bandwidth  = (fcn(2) - fcn(1)) / (2 * Fs);
[bn, an] = iirnotch(centerFreq / Fs, bandwidth);

%% Combined Filter Frequency Response
b_combined = conv(conv(bhp, blp), bn);
a_combined = conv(conv(ahp, alp), an);

figure;
freqz(b_combined, a_combined, 1024, Fs);
title('Combined Filter Frequency Response');

%% Bode Plot of Combined Filter
figure;
[h, f] = freqz(b_combined, a_combined, 1024, Fs);

mag = 20*log10(abs(h));     % Magnitude in dB
phase = unwrap(angle(h));   % Phase in radians

subplot(2,1,1);
plot(f, mag);
title('Bode Plot - Magnitude');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

subplot(2,1,2);
plot(f, phase);
title('Bode Plot - Phase');
xlabel('Frequency (Hz)');
ylabel('Phase (Radians)');

%% Apply Filters (zero-phase using filtfilt)
eegDataFiltered = filtfilt(bhp, ahp, fp1Signal);         % High-pass
eegDataFiltered = filtfilt(bn, an, eegDataFiltered);      % Notch
eegDataFiltered = filtfilt(blp, alp, eegDataFiltered);    % Low-pass

%% Power Spectrum Before & After Filtering
figure;
subplot(2,1,1);
pwelch(fp1Signal, [], [], [], Fs);
title('EEG Power Spectrum Before Filtering');

subplot(2,1,2);
pwelch(eegDataFiltered, [], [], [], Fs);
title('EEG Power Spectrum After Filtering');

%% Time-Domain Signal Visualization
figure;
subplot(2,1,1);
plot(fp1Signal);
title('EEG Signal Before Filtering');
xlabel('Samples');
ylabel('Amplitude');

subplot(2,1,2);
plot(eegDataFiltered);
title('EEG Signal After Filtering');
xlabel('Samples');
ylabel('Amplitude');
