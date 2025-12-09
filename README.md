# EEG-Music-Mood-Cognitive-Analysis  
Analysis of how music influences mood and cognitive performance using EEG signals.  
This project includes data acquisition, pre-processing, brainwave extraction (alpha, beta, theta), and signal energy analysis to observe changes in brain activity before and after music stimulation.

---

## Project Description
This research aims to analyze how music affects mood and cognitive abilities using **single-channel EEG (FP1)**.

The processing pipeline includes:

1. **Import EEG data from .txt file**
2. **Pre-processing**
   - High-pass filter (1 Hz)
   - Notch filter (50 Hz powerline noise)
   - Low-pass filter (40 Hz)
3. **Brainwave extraction**
   - Alpha (8–13 Hz)
   - Beta (14–30 Hz)
   - Theta (4–7 Hz)
4. **Energy analysis**
   - Total energy
   - Comparison between first 5 minutes and last 5 minutes
5. **Signal and spectrum visualization**

---

## 📊 EEG Data
- Format: **TXT**
- Sampling rate: **42,000 Hz**
- Channel used: **FP1**
- Contains low-frequency drift, 50 Hz powerline noise, and movement artifacts.

---

## Pre-Processing
Signal cleaning includes:

- **High-pass 1 Hz** → removes DC drift  
- **Notch 49–51 Hz** → removes 50 Hz powerline noise  
- **Low-pass 40 Hz** → keeps relevant EEG brainwave components  

Output includes:
- Clean EEG signal  
- Power spectrum before vs after filtering  
- Bode plots of each filter  

---

## Brainwave Processing
Extracted brainwave ranges:

| Brainwave | Frequency Range | Associated With |
|-----------|-----------------|-----------------|
| Alpha     | 8–13 Hz         | Relaxation, light focus |
| Beta      | 14–30 Hz        | Concentration, mental activity |
| Theta     | 4–7 Hz          | Creativity, memory, drowsiness |

Butterworth 2nd-order band-pass filters are used for extraction.

---

## ⚡ Brainwave Energy Calculation
Energy is calculated using:

\[
E = \sum x[n]^2
\]

Energy is computed for:
- The full duration of the data  
- The first 5 minutes  
- The last 5 minutes  

Purpose:  
To observe whether music increases or decreases specific brainwave energy levels.

---

## ▶ How to Run
1. Open MATLAB.
2. Ensure the `.txt` EEG file is placed inside the `data/` folder.
3. Run the pre-processing script:
   ```matlab
   preprocessing
4. Run the brainwave processing script:
   ```matlab
     processing
