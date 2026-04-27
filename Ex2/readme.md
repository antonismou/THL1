# Exercise 2 Oral Exam Guide

This file is a short study guide for **Telecommunication Systems I – Exercise 2**. It is meant to help explain the code, plots, and theory clearly during questions from the instructor.

## What the exercise studies

The exercise has two parts:

- **Part A:** spectral content and power spectral density of baseband PAM waveforms.
- **Part B:** a stochastic process of the form $$Y(t)=X\cos(2\pi F_0 t+\Phi)$$.

The main goal in Part A is to connect:

- the pulse shape $$\phi(t)$$,
- the symbol alphabet,
- the symbol period $$T$$,
- and the resulting PSD.

The main goal in Part B is to compute:

- the mean,
- the autocorrelation,
- and the PSD,

and then decide whether the process is wide-sense stationary.

## Part A

### A.1 SRRC pulse

An **SRRC pulse** (Square-Root Raised Cosine) is used because it is a standard pulse for digital communications. Its roll-off factor $$a$$ controls excess bandwidth.

Parameters used:

- $$T=10^{-3}$$ sec
- `over = 10`
- $$T_s=T/\text{over}=10^{-4}$$ sec
- $$A=4$$
- $$a=0.5$$

Important points to say:

- The pulse is truncated in time to the interval of length $$2AT$$.
- The FFT is used to approximate its Fourier transform.
- The plot of $$|\Phi(F)|^2$$ is the **energy spectral density** of the pulse.
- `semilogy` is used because the sidelobes are easier to see on a logarithmic scale.

If asked why `Nf` must be large:

- A large FFT length gives a denser frequency grid.
- If `Nf` is too small, the spectrum and PSD plots look distorted.

### A.2 2-PAM mapping

For 2-PAM, the bits are mapped as:

- `0 -> +1`
- `1 -> -1`

So the symbol sequence is $$X_n \in \{+1,-1\}$$.

Since the bits are independent and equiprobable:

- $$E[X_n]=0$$
- $$\sigma_X^2=E[X_n^2]=1$$

The transmitted waveform is:

$$
X(t)=\sum_{n=0}^{N-1} X_n\,\phi(t-nT)
$$

What this means physically:

- each symbol multiplies one shifted copy of the pulse,
- and the full waveform is the sum of all shifted pulses.

### A.3 2-PAM periodogram and PSD

For one realization, the periodogram is:

$$
P_X(F)=\frac{|\mathcal{F}\{X(t)\}|^2}{T_{\text{total}}}
$$

The theoretical PSD is:

$$
S_X(F)=\frac{\sigma_X^2}{T}|\Phi(F)|^2
$$

For 2-PAM here:

$$
S_X(F)=\frac{1}{T}|\Phi(F)|^2
$$

Key explanation:

- A **single periodogram is noisy**.
- This happens because it is based on only one finite realization.
- Averaging over many realizations reduces variance.
- As $$K$$ increases, the average periodogram gets smoother.
- As $$N$$ increases, the finite-length effect becomes smaller.
- So the experimental estimate gets closer to the theoretical PSD.

If asked *why this happens*:

- averaging reduces randomness across realizations,
- and longer signals give better frequency resolution and better approximation of the infinite-duration model.

### A.4 4-PAM

The mapping is:

- `00 -> +3`
- `01 -> +1`
- `11 -> -1`
- `10 -> -3`

This is Gray-style ordering, because neighboring amplitude levels differ by one bit.

The symbols are equiprobable, so:

- $$X_n \in \{+3,+1,-1,-3\}$$
- $$E[X_n]=0$$
- $$\sigma_X^2=E[X_n^2]=\frac{9+1+1+9}{4}=5$$

Therefore the theoretical PSD is:

$$
S_X(F)=\frac{5}{T}|\Phi(F)|^2
$$

What to observe:

- **Bandwidth:** same as 2-PAM, because the pulse $$\phi(t)$$ and symbol period $$T$$ are the same.
- **Peak magnitude:** larger than 2-PAM, because the symbol variance is larger.
- In fact, the PSD magnitude is scaled by variance, so 4-PAM is 5 times higher than 2-PAM in theory.

If asked why 4-PAM is useful:

- It carries **2 bits per symbol** instead of 1 bit per symbol.
- So for the same symbol rate, it sends data faster.

### A.5 Case with $$T' = 2T$$

Now the symbol period is doubled:

- $$T' = 2T$$
- the sampling period $$T_s$$ stays the same,
- so the oversampling factor must also double.

Why `over` doubles:

$$
\text{over}'=\frac{T'}{T_s}=\frac{2T}{T_s}=2\,\text{over}
$$

Main observation:

- The PSD becomes **narrower in bandwidth**.
- The signal changes more slowly in time, so it occupies less bandwidth.

Simple explanation to say orally:

- A larger symbol period means a lower symbol rate.
- Lower symbol rate means the waveform varies more slowly.
- Slower variation in time means smaller frequency spread.

### A.6 Design choices

If the goal is **maximum data rate for the same bandwidth**:

- choose **4-PAM**, because it transmits 2 bits per symbol while 2-PAM transmits 1 bit per symbol.

If the goal is **smaller bandwidth usage**:

- choose **$$T' = 2T$$**, because increasing the symbol period reduces the occupied bandwidth.

Trade-off:

- 4-PAM improves spectral efficiency,
- but larger constellations are usually more sensitive to noise.
- Increasing $$T$$ saves bandwidth, but lowers the transmission rate.

## Part B

The process is:

$$
Y(t)=X\cos(2\pi F_0 t+\Phi)
$$

with:

- $$X\sim \mathcal{N}(0,1)$$
- $$\Phi\sim U[0,2\pi)$$
- $$X$$ and $$\Phi$$ independent

### B.1 Realizations

Each realization looks like a cosine with:

- random amplitude, because of $$X$$,
- random phase, because of $$\Phi$$.

So different realizations have the same frequency $$F_0$$, but different amplitude and phase.

### B.2 Mean

Compute:

$$
E[Y(t)] = E[X\cos(2\pi F_0 t + \Phi)]
$$

Because $$X$$ is independent of $$\Phi$$:

$$
E[Y(t)] = E[X] \, E[\cos(2\pi F_0 t + \Phi)]
$$

Now:

- $$E[X]=0$$, since $$X\sim \mathcal{N}(0,1)$$
- and the average of cosine over a uniform phase is also 0

Therefore:

$$
E[Y(t)] = 0
$$

### B.2 Autocorrelation

We compute:

$$
R_{YY}(t+\tau,t)=E[Y(t+\tau)Y(t)]
$$

Substitute the definition of $$Y(t)$$:

$$
R_{YY}(t+\tau,t)=E\left[X^2\cos(2\pi F_0(t+\tau)+\Phi)\cos(2\pi F_0 t+\Phi)\right]
$$

Use the identity:

$$
\cos A\cos B = \frac{1}{2}\cos(A-B)+\frac{1}{2}\cos(A+B)
$$

Then:

$$
R_{YY}(t+\tau,t)=\frac{1}{2}E[X^2]\cos(2\pi F_0\tau)+\frac{1}{2}E[X^2\cos(2\pi F_0(2t+\tau)+2\Phi)]
$$

Now:

- $$E[X^2]=1$$
- the second term is zero because averaging over uniform $$\Phi$$ makes the cosine term vanish

So:

$$
R_{YY}(\tau)=\frac{1}{2}\cos(2\pi F_0\tau)
$$

Conclusion:

- the mean is constant,
- the autocorrelation depends only on $$\tau$$, not on $$t$$,
- therefore the process is **wide-sense stationary (WSS)**.

### B.3 PSD

The PSD is the Fourier transform of the autocorrelation:

$$
S_Y(F)=\mathcal{F}\left\{\frac{1}{2}\cos(2\pi F_0\tau)\right\}
$$

Using the standard transform pair:

$$
\mathcal{F}\{\cos(2\pi F_0\tau)\} = \frac{1}{2}\delta(F-F_0)+\frac{1}{2}\delta(F+F_0)
$$

we get:

$$
S_Y(F)=\frac{1}{4}\delta(F-F_0)+\frac{1}{4}\delta(F+F_0)
$$

What to say:

- The process has power only at the frequencies $$+F_0$$ and $$-F_0$$.
- So its PSD is a **line spectrum** with two impulses.

## Very likely questions

### Why do we average many periodograms?

Because one periodogram has high variance. Averaging over many realizations gives a much better PSD estimate.

### Why does 4-PAM have the same bandwidth as 2-PAM here?

Because bandwidth is mainly determined by the pulse shape and the symbol period. Since both are the same, the PSD shape has the same bandwidth.

### Why is the 4-PAM PSD higher?

Because the symbol variance is larger:

- 2-PAM: $$\sigma_X^2=1$$
- 4-PAM: $$\sigma_X^2=5$$

and the PSD is proportional to $$\sigma_X^2$$.

### Why does increasing $$T$$ reduce bandwidth?

Because increasing symbol duration lowers the symbol rate, so the waveform changes more slowly in time and occupies a narrower frequency range.

### Why choose 4-PAM if bandwidth is fixed?

Because it sends 2 bits per symbol, so it achieves a higher bit rate in the same bandwidth.

### Why not always choose 4-PAM?

Because larger constellations have smaller spacing between symbol levels, so they are generally more sensitive to noise and detection errors.

## 30-second summary

- The PSD of PAM is the pulse spectrum scaled by symbol variance and divided by symbol period.
- 2-PAM and 4-PAM have the same bandwidth if they use the same pulse and the same symbol period.
- 4-PAM has larger PSD magnitude because its symbol variance is larger.
- Increasing the symbol period reduces bandwidth.
- In Part B, the process is zero-mean, WSS, and has PSD with impulses at $$\pm F_0$$.