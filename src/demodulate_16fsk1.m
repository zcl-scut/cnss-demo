function y_fsk = demodulate_16fsk1(x_fsk,fs, w_fsk, fp1, fs1, rs, rp, smooth, symbol_rate)
% demodulate_16fsk1 ���ڶ�16fsk�źŽ�����ɽ��
% x_fsk: �����16fsk�����ź�; fs: ������; w_fsk: �ز��źŵĽ�Ƶ��; fp1: ��ͨ�˲���ͨ����ֹƵ��; 
% fs1:��ͨ�˲��������ֹƵ��; rs,rp: �˲�������; smooth: ������Ԫ����; symbol_rate: ��Ԫ����

tao=1/smooth;
t1=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
Fs=fs;
wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %ͨ���߽�Ƶ��
ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %����߽�Ƶ��
[n,wn]=buttord(wp,ws,rp,rs,'s'); %�˲����Ľ���n��-3dB��һ����ֹƵ��Wn
[b,a]=butter(n,wn,'s');
[num,den]=bilinear(b,a,Fs);  %˫���Ա任
y_fsk = zeros(4, length(x_fsk));
symbols = length(x_fsk)/smooth;  %��Ԫ��Ŀ
M = 16;
for iter = 1 : symbols
    y = x_fsk(1, (iter-1)*length(t1)+1:iter*length(t1));
    y_len = length(y);
    detect = zeros(1,y_len);         % Ԥ�ü���ź�
    distance = zeros(1,M);              % ����������Ƶ���µ�ƽ�����
    for j = 1 : M
        y_ = y.*sin(j*w_fsk*t1);       
        y_=filter(num,den,y_);
        distance(j) = mean(abs(y_));        
    end
    for i = 1 : y_len                
        pos = find(distance == max(distance)); % ����о�
        detect(i) = pos(1) - 1; % �����ķ��ţ�ʮ���ƣ�
        y_fsk(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
    end
end
end

