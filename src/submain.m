function [err1,err2,err3]=submain(x1,nowi,fs_music)
symbol_rate=1;%��Ԫ����,Baud/s
fc=1;%ģ���ز�Ƶ��,Hz
smooth=100;
ds=4;%downsample rate,44100������,�ο��²�����:2,3,4,5,6,8
fs=fs_music/ds;%ͨ�Ų���(8khz)ԶС����Ƶ����(40khz)����
l_sam=floor(length(x1)/ds);%����ȡ��
sam1=zeros(l_sam,1);%�����ź�
for i=1:l_sam
    sam1(i)=x1(ds*i);
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

TestBg=10000;TestL=320;
x1Test = x1(TestBg+1:TestBg+TestL);   %�����ź�
bj=0;
if nowi==1
    bj=1;
end
err1=part4(y_fsk,pcm1,TestBg,x1Test,fs_music,smooth,ds,'16fsk Coherent-Demodulation',bj);
err2=part4(y_fsk2,pcm1,TestBg,x1Test,fs_music,smooth,ds,'16fsk Envelope-Demodulation',bj);
err3=part4(y_qam,pcm1,TestBg,x1Test,fs_music,smooth,ds,'16qam Coherent-Demodulation',bj);