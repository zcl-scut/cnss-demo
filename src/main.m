%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%一、1min模拟信号的PCM采样量化编码
% 1.用a率进行非均匀量化
% 2.量化编码后一个电平得到8bit码字
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
[x,fs]=audioread('music.wav');
% sound(x,fs)%播放原音
N=length(x);
t=0:1/fs:(N-1)/fs;

% noise_high=0.1*sin(2*pi*5000*t)%5kHz高频噪声
% noise_low=sin(2*pi*100*t)%100Hz低频噪声
x1=x(:,1);%抽取x第1声道
start=fs*10;%从第10秒开始播放
inteval=150;%截取长度
% figure
% subplot(2,1,1);
% plot(x1(start:start+inteval,1));
% grid;
% subplot(2,1,2);
% stem(x1(start:start+inteval,1));%采样量化处理对象
% grid;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%二、基带调制并显示波形
%1.16FSK和16QAM调制
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%


test_in=[0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,0,1,1,0,1,1,1,1,0,1,1,1,1];
cut=4;%将每4位切片
test_in=reshape(test_in,[],cut);%[]自动计算维度大小
for i = 1:16
    num=bin2dec(num2str(test_in(i,:)));%读取4位数组转化为十进制，再对16bit信息位进行16fsk调制或者16qam调制
end

figure
t=0:0.01:2;
y=sin(2*pi*t);
plot(t,y);














%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%三、高斯信道传输，信号解调
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%




















%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%四、抽样判决，统计误码率
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%



























