# 👤 Face Matching using MATLAB

## 📌 Overview
This project performs **face matching** by comparing two captured images from a webcam.  
It uses a combination of **Local Binary Patterns (LBP)**, **Discrete Fourier Transform (DFT)**, and **Structural Similarity Index (SSIM)** to compute a final similarity score.  

If the score is above a threshold, the system concludes that the two faces match.

---

## ⚙️ Features
- 📷 Capture images directly from **webcam**  
- 🧩 Extract **LBP features** for texture-based comparison  
- 🔢 Apply **DFT analysis** for frequency-domain features  
- 🏗️ Compute **SSIM** for structural similarity  
- 📊 Final **weighted match score** for decision making  
- 📈 Visualization of faces & spectra  

---

## 🧮 Theory & Formulae

### **1. Discrete Fourier Transform (DFT)**
<img src="https://latex.codecogs.com/svg.latex?\Large%20\color{white}F(u,v)=\sum_{x=0}^{M-1}\sum_{y=0}^{N-1}f(x,y)\,e^{-j2\pi\left(\frac{ux}{M}+\frac{vy}{N}\right)}" />

This helps capture **low-frequency features** that preserve structural face information.  

---

### **2. Local Binary Patterns (LBP)**
<img src="https://latex.codecogs.com/svg.latex?\Large%20\color{white}LBP(x_c,y_c)=\sum_{p=0}^{P-1}s(g_p-g_c)\,2^p,\quad%20s(x)=\begin{cases}1&x\geq0\\0&x<0\end{cases}" />

where <img src="https://latex.codecogs.com/svg.latex?\color{white}g_c"/> is the intensity of the center pixel and <img src="https://latex.codecogs.com/svg.latex?\color{white}g_p"/> are neighbor intensities.

---

### **3. Normalized Cross-Correlation (NCC)**
<img src="https://latex.codecogs.com/svg.latex?\Large%20\color{white}NCC(f,g)=\frac{\sum_i(f_i-\bar{f})(g_i-\bar{g})}{\sqrt{\sum_i(f_i-\bar{f})^2}\,\sqrt{\sum_i(g_i-\bar{g})^2}}" />

where <img src="https://latex.codecogs.com/svg.latex?\color{white}\bar{f}"/> and <img src="https://latex.codecogs.com/svg.latex?\color{white}\bar{g}"/> are mean values.

---

### **4. Structural Similarity Index (SSIM)**
<img src="https://latex.codecogs.com/svg.latex?\Large%20\color{white}SSIM(x,y)=\frac{(2\mu_x\mu_y+C_1)(2\sigma_{xy}+C_2)}{(\mu_x^2+\mu_y^2+C_1)(\sigma_x^2+\sigma_y^2+C_2)}" />

where:  
- <img src="https://latex.codecogs.com/svg.latex?\color{white}\mu_x"/> , <img src="https://latex.codecogs.com/svg.latex?\color{white}\mu_y"/> = mean intensities  
- <img src="https://latex.codecogs.com/svg.latex?\color{white}\sigma_x^2"/> , <img src="https://latex.codecogs.com/svg.latex?\color{white}\sigma_y^2"/> = variances  
- <img src="https://latex.codecogs.com/svg.latex?\color{white}\sigma_{xy}"/> = covariance  
- <img src="https://latex.codecogs.com/svg.latex?\color{white}C_1"/> , <img src="https://latex.codecogs.com/svg.latex?\color{white}C_2"/> = constants for stability  

---

### **5. Wiener Filter (for preprocessing)**
<img src="https://latex.codecogs.com/svg.latex?\Large%20\color{white}H_w(u,v)=\frac{S_x(u,v)}{S_x(u,v)+S_n(u,v)}" />

where <img src="https://latex.codecogs.com/svg.latex?\color{white}S_x"/> = power spectrum of signal, <img src="https://latex.codecogs.com/svg.latex?\color{white}S_n"/> = power spectrum of noise.

---

## 🚀 Methodology
1. Capture two images (reference & test)  
2. Preprocess with grayscale, resizing, Wiener filter, and adaptive histogram equalisation  
3. Extract **LBP features** → compute NCC  
4. Apply **2D FFT** → extract low-frequency spectrum → compute NCC  
5. Compute **SSIM** between both images  
6. Combine scores into a final weighted score:  

<img src="https://latex.codecogs.com/svg.latex?\Large%20\color{white}MatchScore=0.4\cdot%20SSIM+0.3\cdot%20NCC_{LBP}+0.3\cdot%20NCC_{DFT}" />

7. If score ≥ 70%, conclude **Faces Match ✅**  

---



