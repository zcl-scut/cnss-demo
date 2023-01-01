slCharacterEncoding('UTF-8');
%slCharacterEncoding('GBK');
%%���������������
%https://www.cnblogs.com/leoking01/p/8269516.html


clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%һ��1minģ���źŵ�PCM������������
% 1.��a�ʽ��зǾ�������
% 2.���������һ����ƽ�õ�8bit����
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
[x,fs_music]=audioread('music.wav');
% sound(x,fs)%����ԭ��
N=length(x);
t=0:1/fs_music:(N-1)/fs_music;


x1=x(:,1);%��ȡx��1����
x2=x(:,2);%��ȡx��2����

cut=15;%��ȡ15s����
% x1=x1(1:fs_music*cut);
% x2=x2(1:fs_music*cut);
TestL=320;
x1 = x1(10001:10000+TestL);   %�����ź�

start=fs_music*10;%�ӵ�10�뿪ʼ����
inteval=fs_music/300;%��ȡ����,1/300s

ds=4;%downsample rate,44100������,�ο��²�����:2,3,4,5,6,8
fs=fs_music/ds;%ͨ�Ų���(8khz)ԶС����Ƶ����(40khz)����
l_sam=floor(length(x1)/ds);%����ȡ��
sam1=zeros(l_sam,1);%�����ź�
sam2=zeros(l_sam,1);%�����ź�
for i =1:l_sam
    sam1(i)=x1(ds*i);
    sam2(i)=x2(ds*i);
end


% %��������ź�,�����������
pcm1=quantization(sam1);




%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�����������Ʋ���ʾ����
%1.16FSK��16QAM����
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

symbol_rate=1;%��Ԫ����,Baud/s
fc=10;%ģ���ز�Ƶ��,Hz
smooth=500;
fsk16=fsk16mod(pcm1,symbol_rate,fc,smooth,false,1e4);
qam16=qam16mod(pcm1,symbol_rate,fc,smooth,false,1e4);

%%%%%%%%%%%%%%%%%%%%%
% %16QAM����ͼ
%%%%%%%%%%%%%%%%%%%%%
constell_diag=[1 1;1 3;1 -1;1 -3;3 1;3 3;3 -1;3 -3;-1 1;-1 3;-1 -1;-1 -3;-3 1;-3 3;-3 -1;-3 -3];
% %������һ��,(2,2)��һ��ģΪ1
constell_diag=constell_diag./2/sqrt(2);






%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%������˹�ŵ����䣬�źŽ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ��˹�ŵ�����
w_fsk=2*pi*fc;
w_qam=2*pi*fc;
x_qam = qam16;
x_fsk = fsk16;
SNR_indB = -1;
x_qam = awgn(x_qam, SNR_indB);
x_fsk = awgn(x_fsk, SNR_indB);

% 16QAM���
tao=1/smooth;
t2=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
M = 16;
y_qam = zeros(4, length(x_qam));
symbols = TestL/2;  %�����źų���
for iter = 1 : symbols
    y = x_qam(1, (iter-1)*length(t2)+1:iter*length(t2));
    y_len = length(y);
    detect = zeros(1,y_len);         % Ԥ�ü���ź�
    distance = zeros(1,M);              % �����������
    I = y.*cos(w_qam*t2)*2;
    Q = -y.*sin(w_qam*t2)*2;
    
    %��Ƶ�ͨ�˲���
    Fs=fs;
    fp1=100;fs1=200;rs=10;rp=1;
    wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %ͨ���߽�Ƶ��
    ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %����߽�Ƶ��
    [n,wn]=buttord(wp,ws,rp,rs,'s'); %�˲����Ľ���n��-3dB��һ����ֹƵ��Wn
    [b,a]=butter(n,wn,'s');
    [num,den]=bilinear(b,a,Fs);  %˫���Ա任
    I=filter(num,den,I);
    Q=filter(num,den,Q);
    [h,w]=freqz(num,den,100,Fs);
    figure(1)
    plot(w,abs(h));
    xlabel('Ƶ��/Hz');
    ylabel('��ֵ');
    title('������˹��ͨ�˲�����������');
    grid on;
    for i = 1 : y_len
        for j = 1 : M
            distance(j) = sqrt((I(i)-constell_diag(j,1))^2 + (Q(i)-constell_diag(j,2))^2); %�����źŵ�����������ľ���
        end
        pos = find(distance == min(distance)); % ��С�����������λ��
        detect(i) = pos(1) - 1; % �����ķ��ţ�ʮ���ƣ�
        y_qam(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
    end
end

%16FSK���
%��Ƶ�ͨ�˲���
tao=1/smooth;
t1=0:tao/symbol_rate:1/symbol_rate-tao/symbol_rate;
Fs=fs;
fp1=1000;fs1=1200;rs=10;rp=2;
wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %ͨ���߽�Ƶ��
ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %����߽�Ƶ��
[n,wn]=buttord(wp,ws,rp,rs,'s'); %�˲����Ľ���n��-3dB��һ����ֹƵ��Wn
[b,a]=butter(n,wn,'s');
[num,den]=bilinear(b,a,Fs);  %˫���Ա任
[h,w]=freqz(num,den,100,Fs);
figure(2)
plot(w,abs(h));
xlabel('Ƶ��/Hz');
ylabel('��ֵ');
title('������˹��ͨ�˲�����������');
grid on;
y_fsk = zeros(4, length(x_fsk));
for iter = 1 : symbols
    y = x_fsk(1, (iter-1)*length(t1)+1:iter*length(t1));
    y_len = length(y);
    detect = zeros(1,y_len);         % Ԥ�ü���ź�
    distance = zeros(1,M);              % �����������
    for j = 1 : M
        y_ = y.*sin(j*w_fsk*t1);       
        y_=filter(num,den,y_);
%         
        distance(j) = mean(abs(y_));        
    end
    for i = 1 : y_len                
        pos = find(distance == max(distance)); % ����о�
        detect(i) = pos(1) - 1; % �����ķ��ţ�ʮ���ƣ�
        y_fsk(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�ġ������о���ͳ��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
part4(y_fsk,pcm1,x1)
part4(y_qam,pcm1,x1)
