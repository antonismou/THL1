# Exercise 2: Baseband PAM & Stochastic Processes - Interview Guide

This document summarizes the key concepts for the oral examination of Exercise 2.

## Part A: Baseband PAM Waveforms

### 1. SRRC Pulse ($\phi(t)$)
*   **Definition**: The Square-Root Raised Cosine (SRRC) pulse is used because its convolution with itself (at the receiver) results in a Raised Cosine (RC) pulse, which satisfies the **Nyquist ISI criterion**.
*   **Energy Spectral Density (ESD)**: $|\Phi(F)|^2$ represents how energy is distributed across frequencies. For an SRRC pulse, this looks like a flat passband with a "smooth" roll-off determined by $\alpha$.

### 2. PAM Mappings (2-PAM vs 4-PAM)
*   **2-PAM**: 1 bit/symbol. Symbols: $\{+1, -1\}$. Variance $\sigma_X^2 = 1$.
*   **4-PAM**: 2 bits/symbol. Symbols: $\{+3, +1, -1, -3\}$. Variance $\sigma_X^2 = 5$ (assuming equiprobable bits).
*   **Gray Coding**: We use $01 \to +1$ and $11 \to -1$ so that adjacent symbols differ by only one bit. This minimizes bit error rate (BER) if a symbol is misidentified as its neighbor.

### 3. Power Spectral Density (PSD)
*   **Formula**: $S_X(F) = \frac{\sigma_X^2}{T} |\Phi(F)|^2$.
*   **Estimation**: We use the **Periodogram** method: $P_X(F) = \frac{|\mathcal{F}\{X(t)\}|^2}{T_{total}}$. 
*   **Averaging**: A single realization is "noisy". By averaging $K=500$ realizations, we converge to the theoretical PSD (Law of Large Numbers).
*   **Bandwidth Comparison**:
    *   **2-PAM vs 4-PAM (same $T$)**: They occupy the **same bandwidth** because the pulse $\phi(t)$ is the same. However, 4-PAM transmits data **twice as fast** (2 bits/T).
    *   **Increasing $T$ to $2T$**: The bandwidth is **halved**. Pulse duration in time doubles, so its frequency "footprint" shrinks.

---

## Part B: Stochastic Processes

### 1. Process Definition
$Y(t) = X \cos(2\pi F_0 t + \Phi)$, where $X \sim N(0,1)$ and $\Phi \sim U(0, 2\pi)$.

### 2. Mean $E[Y(t)]$
*   $E[Y(t)] = E[X] \cdot E[\cos(2\pi F_0 t + \Phi)] = 0 \cdot (\dots) = 0$.
*   The process is **zero-mean**.

### 3. Autocorrelation $R_{YY}(t+\tau, t)$
*   Through trigonometric identity $\cos(A)\cos(B) = \frac{1}{2}[\cos(A-B) + \cos(A+B)]$:
*   $R_{YY}(\tau) = \frac{1}{2} \cos(2\pi F_0 \tau)$.
*   Since the mean is constant (0) and the autocorrelation depends only on the time difference $\tau$, the process is **Wide-Sense Stationary (WSS)**.

### 4. PSD $S_Y(F)$
*   $S_Y(F) = \mathcal{F}\{R_{YY}(\tau)\} = \frac{1}{4} [\delta(F - F_0) + \delta(F + F_0)]$.
*   The spectrum consists of two impulses at $\pm F_0$.

---

## Likely Interview Questions
1.  **Why do we use $K=500$ realizations?** To reduce the variance of the periodogram estimate. A single realization is not a consistent estimator of the PSD.
2.  **Why did the 4-PAM PSD look higher than 2-PAM?** Because $\sigma_{X, 4PAM}^2 = 5$ while $\sigma_{X, 2PAM}^2 = 1$. The shape is the same, but the magnitude is $5\times$ higher.
3.  **If bandwidth is expensive, what do you change?** Increase $T$ (symbol period) or decrease $\alpha$ (roll-off).
4.  **Is $Y(t)$ WSS?** Yes, because $E[Y(t)]$ is constant and $R_{YY}$ depends only on $\tau$.
