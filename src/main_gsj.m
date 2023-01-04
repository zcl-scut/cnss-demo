
%slCharacterEncoding('GBK');
%%���������������
%https://www.cnblogs.com/leoking01/p/8269516.html

close all;
clear all;
slCharacterEncoding('UTF-8');
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
symbol_rate=1;%��Ԫ����,Baud/s
fc=1;%ģ���ز�Ƶ��,Hz
smooth=100;
[x,fs_music]=audioread('music.wav');
% sound(x,fs)%����ԭ��
N=length(x);
t=0:1/fs_music:(N-1)/fs_music;


x1=x(:,1);%��ȡx��1����
%x2=x(:,2);%��ȡx��2����

cut=15;%��ȡ15s����
x1=x1(1:fs_music*cut);
% x2=x2(1:fs_music*cut);
TestL=320;
%x1 = x1(10001:10000+TestL);   %�����ź�

start=fs_music*10;%�ӵ�10�뿪ʼ����
inteval=fs_music/300;%��ȡ����,1/300s

ds=4;%downsample rate,44100������,�ο��²�����:2,3,4,5,6,8
fs=fs_music/ds;%ͨ�Ų���(8khz)ԶС����Ƶ����(40khz)����
l_sam=floor(length(x1)/ds);%����ȡ��
sam1=zeros(l_sam,1);%�����ź�
%sam2=zeros(l_sam,1);%�����ź�
for i =1:l_sam
    sam1(i)=x1(ds*i);
%    sam2(i)=x2(ds*i);
end


% %��������ź�,�����������
pcm1=quantization(sam1);
clear sam1;

length(pcm1)


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
clear qam16; clear fsk16;
SNR_indB = 3;
x_qam = awgn(x_qam, SNR_indB);
x_fsk = awgn(x_fsk, SNR_indB);

% 16QAM���
%  fp1=10;fs1=30;rs=5;rp=0.5;
fp1=50;fs1=100;rs=12;rp=0.5;
y_qam = demodulate_16qam(x_qam,fs, w_qam, fp1, fs1, rs, rp, smooth, symbol_rate);
clear x_qam;

%16FSK���
%��Ƶ�ͨ�˲���
fp1=1000;fs1=1200;rs=10;rp=2;
y_fsk = demodulate_16fsk1(x_fsk,fs, w_fsk, fp1, fs1, rs, rp, smooth, symbol_rate);
df = 10; M = 16;
y_fsk2 = demodulate_16fsk2(x_fsk, fs, fc, smooth);
clear x_fsk;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�ġ������о���ͳ��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%


part4(y_fsk,pcm1,x1, smooth)
part4(y_fsk2,pcm1,x1, smooth)
part4(y_qam,pcm1,x1, smooth)

