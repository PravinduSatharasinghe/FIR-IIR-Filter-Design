%4800/(2*pi) sampling frequency in Hz
fsm = 763.944;
%passband and stopband edge frequencies
edge_frequencies = [159.155 206.901 286.479 318.309]; %[1000 1300 1800 2000]/(2*pi)
mags = [0 1 0];
devs = [0.00125893 0.0086345 0.00125893]; % passband and stopband deviations

%Calculating the minimum order(n) that satisfies above specifications and the independent parameter of the Kaiser window 
[n,Wn,beta,ftype] = kaiserord(edge_frequencies,mags,devs,fsm); 
n
n = n + rem(n,2);

%Designing the FIR filter with Kaiser windowing method with corresponding
%order(n)
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');

%Get the magnitude response of the filter
[H,f] = freqz(hh,1,1024,fsm);

%ploting the magnitude response in dB vs. angular frequency (rad/sample)
plot([-(2*pi*f)/fsm (2*pi*f)/fsm],(20*log(abs(H))))
xlim([-pi pi])

%limitng x axis to passband edges
xlim([206.901 286.479]*((2*pi)/fsm))

xlabel('Discrete time angular frequency rad/sample')
ylabel('Magnitude in dB')
%title('Magnitude response in dB (-\pi < \omega < \pi)')
title('Magnitude response in dB (-\omega_p_1 < \omega < \omega_p_2)')
grid

%Get the impulse response of the filter 
impz(hh,n)
