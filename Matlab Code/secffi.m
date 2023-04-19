% Specify the number of antennas at the transmitter and receiver
Nt = 12;
Nr = 12;
L = 256; 


lhbfr1=load("C:\Users\user\Downloads\lstmhbfr.mat");
lhbfi1=load("C:\Users\user\Downloads\lstmhbfi.mat"); 
rhbfr1=load("C:\Users\user\Downloads\rnnhbfr.mat");
rhbfi1=load("C:\Users\user\Downloads\rnnhbfi.mat");

cnlr1=load("C:\Users\user\Downloads\cnntcnlr220.mat");
cnli1=load("C:\Users\user\Downloads\cnntcnli220.mat");

hbfr1=load("C:\Users\user\Downloads\cnnhbfr220.mat");
hbfi1=load("C:\Users\user\Downloads\cnnhbfi220.mat"); 

hbfr4=cell2mat(struct2cell(hbfr1));
hbfi4=cell2mat(struct2cell(hbfi1));

lhbfr4=cell2mat(struct2cell(lhbfr1));
lhbfi4=cell2mat(struct2cell(lhbfi1));
rhbfr4=cell2mat(struct2cell(rhbfr1));
rhbfi4=cell2mat(struct2cell(rhbfi1));
cnlr4=cell2mat(struct2cell(cnlr1));
cnli4=cell2mat(struct2cell(cnli1));

cnlr=reshape(cnlr4,12,256);
cnli=reshape(cnli4,12,256);
hbfr=reshape(hbfr4,12,256);
hbfi=reshape(hbfi4,12,256);
lhbfr=reshape(lhbfr4,12,256);
lhbfi=reshape(lhbfi4,12,256);
rhbfr=reshape(rhbfr4,12,256);
rhbfi=reshape(rhbfi4,12,256);
R1=complex(rhbfr,rhbfi);
L1=complex(lhbfr,lhbfi);
H1=complex(cnlr,cnli);
hbfs=complex(hbfr,hbfi);
mx = max(hbfs(:));
mn = min(hbfs(:));


% Loop over the matrix to find the maximum and minimum values
for i = 1:size(hbfs,1)
    for j = 1:size(hbfs,2)
        if hbfs(i,j) > mx
            mx = hbfs(i,j);
        end
        if hbfs(i,j) < mn
            mn = hbfs(i,j);
        end
    end
end

% Loop over the matrix again to perform the scaling operation
HBF = zeros(size(hbfs));
for i = 1:size(hbfs,1)
    for j = 1:size(hbfs,2)
        HBF(i,j) = (hbfs(i,j) - mn)/(mx - mn);
    end
end
rmx = max(R1(:));
rmn = min(R1(:));
for i = 1:size(R1,1)
    for j = 1:size(R1,2)
        if R1(i,j) > rmx
            rmx = R1(i,j);
        end
        if R1(i,j) < rmn
            rmn = R1(i,j);
        end
    end
end

% Loop over the matrix again to perform the scaling operation
RHBF = zeros(size(hbfs));
for i = 1:size(R1,1)
    for j = 1:size(R1,2)
        RHBF(i,j) = (R1(i,j) - rmn)/(rmx - rmn);
    end
end
lmx = max(L1(:));
lmn = min(L1(:));
for i = 1:size(L1,1)
    for j = 1:size(L1,2)
        if L1(i,j) > lmx
            lmx = L1(i,j);
        end
        if L1(i,j) < lmn
            lmn = L1(i,j);
        end
    end
end

% Loop over the matrix again to perform the scaling operation
LHBF = zeros(size(hbfs));
for i = 1:size(R1,1)
    for j = 1:size(R1,2)
        LHBF(i,j) = (R1(i,j) - lmn)/(lmx - lmn);
    end
end

mag_h = abs(H1);

% Normalize the complex number
H = H1 / mag_h;
% Specify the SNR range (in dB)
snr_dB = -10:5:30;
snr = 10.^(snr_dB./10);
%BER = zeros(size(Ptx));
Heffcnn = H*HBF;
Hefflstm = H*LHBF;
Heffrnn = H*RHBF;

% Initialize the spectral efficiency vector
Scnn = zeros(size(snr));
Slstm = zeros(size(snr));
Srnn = zeros(size(snr));

for i = 1:length(snr)
    % Generate random data symbols
    data = randi([0,1], L, 1);
    % Modulate the data symbols to QPSK symbols
    mod_data = qammod(data, 4);
    
    P = snr(i)/(Nt*L);

    % Generate the received signal
   
    y1cnn = Heffcnn*mod_data ;
    y1lstm = Hefflstm*mod_data ;
    y1rnn = Heffrnn*mod_data ;
    ycnn = awgn(y1cnn, snr(i), 'measured');
    ylstm = awgn(y1lstm, snr(i), 'measured');
    yrnn = awgn(y1rnn, snr(i), 'measured');
    % Calculate the received signal power
    P_rxcnn = norm(y1cnn)^2;
    P_rxlstm = norm(y1lstm)^2;
    P_rxrnn = norm(y1rnn)^2;
    % Calculate the spectral efficiency
    Scnn(i) = log2(1 + P*P_rxcnn);
    Slstm(i) = log2(1 + P*P_rxlstm);
    Srnn(i) = log2(1 + P*P_rxrnn);
end

% Plot the spectral efficiency versus SNR
figure;
plot(snr_dB, Scnn, 'r-s');
hold on;
plot(snr_dB, Srnn, 'g-*');
hold on;
plot(snr_dB, Slstm, 'b-o');
legend('CNN-GRU','CNN-RNN','CNN-BiLSTM','Location','northwest')
grid;
xlabel('SNR (dB)');
ylabel('Spectral Efficiency (bps/Hz)');
title('Spectral Efficiency vs. SNR');
grid on;
