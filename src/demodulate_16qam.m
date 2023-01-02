function y_qam = demodulate_16qam(x_qam,fs, w_qam, fp1, fs1, rs, rp, smooth, symbol_rate)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% demodulate_16qam��������16QAM�źŵĽ��
constell_diag=[1 1;1 3;1 -1;1 -3;3 1;3 3;3 -1;3 -3;-1 1;-1 3;-1 -1;-1 -3;-3 1;-3 3;-3 -1;-3 -3];
% %������һ��,(2,2)��һ��ģΪ1
constell_diag=constell_diag./2/sqrt(2);
tao=1/smooth;
t2=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
M = 16;
y_qam = zeros(4, length(x_qam));
symbols = length(x_qam)/smooth;  %�����źų���
Fs=fs;
wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %ͨ���߽�Ƶ��
ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %����߽�Ƶ��
[n,wn]=buttord(wp,ws,rp,rs,'s'); %�˲����Ľ���n��-3dB��һ����ֹƵ��Wn
[b,a]=butter(n,wn,'s');
[num,den]=bilinear(b,a,Fs);  %˫���Ա任
%     [h,w]=freqz(num,den,100,Fs);
%     figure(1)
%     plot(w,abs(h));
%     xlabel('Ƶ��/Hz');
%     ylabel('��ֵ');
%     title('������˹��ͨ�˲�����������');
%     grid on;
for iter = 1 : symbols
    y = x_qam(1, (iter-1)*length(t2)+1:iter*length(t2));
    y_len = length(y);
    detect = zeros(1,y_len);         % Ԥ�ü���ź�
    distance = zeros(1,M);              % �����������
    I = y.*cos(w_qam*t2)*2;
    Q = -y.*sin(w_qam*t2)*2;
    
    %��Ƶ�ͨ�˲���

    I=filter(num,den,I);
    Q=filter(num,den,Q);

    for i = y_len : y_len
        for j = 1 : M
            distance(j) = sqrt((I(i)-constell_diag(j,1))^2 + (Q(i)-constell_diag(j,2))^2); %�����źŵ�����������ľ���
        end
        pos = find(distance == min(distance)); % ��С�����������λ��
        detect(i) = pos(1) - 1; % �����ķ��ţ�ʮ���ƣ�
        y_qam(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
    end
end
end

