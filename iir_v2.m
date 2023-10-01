%Prewarped Passband Edge Angular Frequencies in rad/s
Wp = [1744.063 3688.6466];

%Prewarped Stopband Edge Angular Frequencies in rad/s
Ws = [1185.151 5702.154]; %[1000 1300 1800 2000];

%Passband Maximum Ripple
Rp = 0.15;

%Stopband Minimum Ripple
Rs = 58;

%Sampling Frequency in Hz
fsamp=4800/(2*pi);

%Get the order of the IIR filter that satisfies above specifications
[n,Wp] = cheb1ord(Wp,Ws,Rp,Rs,'s');

%Order of the Filter
n

%Get the zeros, poles and the gains of the normalized lowpass filter
[z,p,k] = cheb1ap(n,Rp);
%state-space representation of the normalized lowpass filter
[A,B,C,D] = zp2ss(z,p,k);

%Specifying the passband edge continuous time angular frequencies, corresponding discrete
%time angular frequencies
u1 = 1744.063;
u2 = 3688.6466;
w1 = (2*pi*1300)/4800;
w2 = (2*pi*1800)/4800;

%Discrete time angular frequencies corresponding to the passband continuous
%time angular frequencies that are not prewarped
uw1 = u1/fsamp;
uw2 = u2/fsamp;

%state-space represntation of the analog filter, that is converted from
%lowpass to bandpass
[At,Bt,Ct,Dt] = lp2bp(A,B,C,D,sqrt(u1*u2),u2-u1);

%Get the numerator and the denominator of the filter transfer function
[b,a] = ss2tf(At,Bt,Ct,Dt);

%Get the transfer function of the analog bandpass filter
[h,w] = freqs(b,a,2048);

%state-space representation of the discrete time filter using bilinear
%transformation
[Ad,Bd,Cd,Dd] = bilinear(At,Bt,Ct,Dt,fsamp);

%discrete time zeros, poles and gains
[zd,pd,kd] = ss2zp(Ad,Bd,Cd,Dd);

%Numerator and the denominator of the trnasfer function of digital
%filter
[num,den] = zp2tf(zd,pd,kd);

%Get the table of coefficients of both numerator and the denominator of the
%transfer function of digital filter
% Table_of_numerator_and_denominator_coeficients=table(num.',den.');
% Table_of_numerator_and_denominator_coeficients.Properties.VariableNames = {'Numerator','Denominator'};
% Table_of_numerator_and_denominator_coeficients


%Get the magnitude response in dB of the digital filter
[hd,wd] = freqz(ss2sos(Ad,Bd,Cd,Dd),2048);


plot(wd,mag2db(abs(hd)))
xline([w1 w2],"-",["Lower" "Upper"]+" passband edge", ...
    LabelVerticalAlignment="middle")

xline([uw1 uw2],'--r',["Unwarped lower" "Unwarped upper"]+" passband edge", ...
    LabelVerticalAlignment="top")

ylim([-165 5])
xlim([-pi pi])

%limiting the x axis with passband edges at the two ends
xlim([w1 w2])
title('Magnitude Response of the Filter for -\pi < \omega < \pi rad/sample')
xlabel("angular frequency (rad/sample)")
ylabel("Magnitude (dB)")
grid