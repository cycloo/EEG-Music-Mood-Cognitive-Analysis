%% Brainwave Signal Processing
% Frequency ranges for brain waves
alphaRange = [8 13];
betaRange  = [14 30];
thetaRange = [4 7];

%% Design band-pass filters for each brainwave
[b_alpha, a_alpha] = butter(2, alphaRange/(Fs/2), 'bandpass');
[b_beta,  a_beta ] = butter(2, betaRange /(Fs/2), 'bandpass');
[b_theta, a_theta] = butter(2, thetaRange/(Fs/2), 'bandpass');

%% Frequency response visualization
figure('Name','Filter Responses','NumberTitle','off');
freqz(b_alpha, a_alpha, 1024, Fs);
title('Alpha Filter Response');

figure('Name','Alpha Bode Plot','NumberTitle','off');
[h_alpha, w_alpha] = freqz(b_alpha, a_alpha, 1024, Fs);
bode_plot(h_alpha, w_alpha, Fs);

figure('Name','Beta Bode Plot','NumberTitle','off');
freqz(b_beta, a_beta, 1024, Fs);
[h_beta, w_beta] = freqz(b_beta, a_beta, 1024, Fs);
bode_plot(h_beta, w_beta, Fs);

figure('Name','Theta Bode Plot','NumberTitle','off');
freqz(b_theta, a_theta, 1024, Fs);
[h_theta, w_theta] = freqz(b_theta, a_theta, 1024, Fs);
bode_plot(h_theta, w_theta, Fs);

%% Filter EEG data into brainwave bands
alphaWave = filter(b_alpha, a_alpha, eegDataFiltered);
betaWave  = filter(b_beta,  a_beta,  eegDataFiltered);
thetaWave = filter(b_theta, a_theta, eegDataFiltered);

%% Plot filtered brainwaves
figure('Name','Filtered Brain Waves','NumberTitle','off');
subplot(3,1,1);
plot(alphaWave);
title('Alpha Wave');

subplot(3,1,2);
plot(betaWave);
title('Beta Wave');

subplot(3,1,3);
plot(thetaWave);
title('Theta Wave');

%% Duration calculation (5 minutes)
actualNumSamples = length(eegDataFiltered);
desiredDurationSec = 5 * 60;           % 5 minutes → 300 seconds
desiredNumSamples = desiredDurationSec * Fs;

% Samples used must not exceed available data
numSamplesToUse = min(desiredNumSamples, actualNumSamples);

%% Energy of each wave (full available duration)
alphaEnergy = sum(alphaWave(1:numSamplesToUse).^2);
betaEnergy  = sum(betaWave (1:numSamplesToUse).^2);
thetaEnergy = sum(thetaWave(1:numSamplesToUse).^2);

fprintf('Alpha Energy (available duration): %f\n', alphaEnergy);
fprintf('Beta Energy  (available duration): %f\n', betaEnergy);
fprintf('Theta Energy (available duration): %f\n', thetaEnergy);

%% Check availability for first & last 5-minute window
fiveMinSamples = 5 * 60 * Fs;   % Correct: 5 minutes in samples

if actualNumSamples < 2 * fiveMinSamples
    error('Not enough data for 5-minute start and end analysis.\nAvailable: %d samples, Required: %d samples', ...
        actualNumSamples, 2 * fiveMinSamples);
end

%% Compute start & end 5-min energies
alphaEnergyFirst5min = sum(alphaWave(1:fiveMinSamples).^2);
alphaEnergyLast5min  = sum(alphaWave(end-fiveMinSamples+1:end).^2);

betaEnergyFirst5min  = sum(betaWave(1:fiveMinSamples).^2);
betaEnergyLast5min   = sum(betaWave(end-fiveMinSamples+1:end).^2);

thetaEnergyFirst5min = sum(thetaWave(1:fiveMinSamples).^2);
thetaEnergyLast5min  = sum(thetaWave(end-fiveMinSamples+1:end).^2);

%% Print results
fprintf('\n--- 5 Minute Energy Comparison ---\n');
fprintf('Alpha  First 5 min: %f\n', alphaEnergyFirst5min);
fprintf('Alpha  Last  5 min: %f\n', alphaEnergyLast5min);

fprintf('Beta   First 5 min: %f\n', betaEnergyFirst5min);
fprintf('Beta   Last  5 min: %f\n', betaEnergyLast5min);

fprintf('Theta  First 5 min: %f\n', thetaEnergyFirst5min);
fprintf('Theta  Last  5 min: %f\n', thetaEnergyLast5min);

%% Plot energy signals
timeVector = (1:numSamplesToUse) / Fs;

figure;
subplot(3,1,1);
plot(timeVector, alphaWave(1:numSamplesToUse).^2);
title('Alpha Wave Energy');
ylabel('Energy');

subplot(3,1,2);
plot(timeVector, betaWave(1:numSamplesToUse).^2);
title('Beta Wave Energy');
ylabel('Energy');

subplot(3,1,3);
plot(timeVector, thetaWave(1:numSamplesToUse).^2);
title('Theta Wave Energy');
xlabel('Time (seconds)');
ylabel('Energy');


%% Bode Plot Function
function bode_plot(h, w, Fs)
    mag = 20*log10(abs(h));
    phase = unwrap(angle(h));
    f = w * Fs / (2*pi);

    subplot(2,1,1);
    plot(f, mag);
    title('Magnitude Response');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');

    subplot(2,1,2);
    plot(f, phase);
    title('Phase Response');
    xlabel('Frequency (Hz)');
    ylabel('Phase (Radians)');
end
