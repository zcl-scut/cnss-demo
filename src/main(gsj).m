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
[x,fs]=audioread('music.wav');
% sound(x,fs)%����ԭ��
N=length(x);
t=0:1/fs:(N-1)/fs;

% noise_high=0.1*sin(2*pi*5000*t)%5kHz��Ƶ����
% noise_low=sin(2*pi*100*t)%100Hz��Ƶ����
x1=x(:,1);%��ȡx��1����
start=fs*10;%�ӵ�10�뿪ʼ����
inteval=150;%��ȡ����
% figure
% subplot(2,1,1);
% plot(x1(start:start+inteval,1));
% grid;
% subplot(2,1,2);
% stem(x1(start:start+inteval,1));%���������������
% grid;


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


test_in=[0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,0,1,1,0,1,1,1,1,0,1,1,1,1];
cut=4;%��ÿ4λ��Ƭ
test_in=reshape(test_in,cut,[]);%[]�Զ�����ά�ȴ�С
fsk16=[];
t1=0:0.001:1;
symbols=4;%��ʾ1~8������
w_fsk=2*pi*4*10;%����Ϊ1
for i = 1:symbols
    num=bin2dec(num2str(test_in(:,i)'));%��ȡ4λ����ת��Ϊʮ���ƣ��ٶ�16bit��Ϣλ����16fsk���ƻ���16qam����
    fsk16=[fsk16,sin((num+1)*w_fsk*t1)];%��(num+1)����Ƶ�ʵ���
end
% 
% figure
% subplot(2,1,1)
% carrier=repmat(sin(w_fsk*t)',symbols,1);
% plot(carrier);
% title('�ز�����')
% subplot(2,1,2)
% plot(fsk16);%����16fsk�Ĳ���
% title('16fsk���Ʋ���')


%16QAM����ͼ
constell_diag=[1 1;1 3;1 -1;1 -3;3 1;3 3;3 -1;3 -3;-1 1;-1 3;-1 -1;-1 -3;-3 1;-3 3;-3 -1;-3 -3];
%������һ��,(2,2)��һ��ģΪ1
constell_diag=constell_diag./2/sqrt(2);
qam16=[];
t=0:0.005:1;
w_qam=2*pi*4*10;%����Ϊ1/4,Ϊ�˿��ӻ����ÿ���ʹģ�����ڡ�4=��Ԫ����
symbols=4;%��ʾ1~4������
for i = 1:symbols   
    num=bin2dec(num2str(test_in(:,i)'));%��ȡ4λ����ת��Ϊʮ���ƣ��ٶ�16bit��Ϣλ����16fsk���ƻ���16qam����
    qam_sig=constell_diag(num+1,1)*cos(w_qam*t)-constell_diag(num+1,2)*sin(w_qam*t);
    qam16=[qam16,qam_sig];%��(num+1)����Ƶ�ʵ���
end

% figure
% subplot(2,1,1)
% carrier=repmat(cos(w_qam*t)',symbols,1);
% plot(carrier);
% title('�ز�����')
% subplot(2,1,2)
% plot(qam16);%����16qam�Ĳ���
% title('16qam���Ʋ���')





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
x_qam = qam16;
x_fsk = fsk16;
SNR_indB = 10;
% x_qam = awgn(x_qam, SNR_indB);
% x_fsk = awgn(x_fsk, SNR_indB);

% 16QAM���
M = 16;
y_qam = zeros(4, length(x_qam));
for iter = 1 : symbols
    y = x_qam(1, (iter-1)*length(t)+1:iter*length(t));
    y_len = length(y);
    detect = zeros(1,y_len);         % Ԥ�ü���ź�
    distance = zeros(1,M);              % �����������
    I = y.*cos(w_qam*t)*2;
    Q = -y.*sin(w_qam*t)*2;
    
    %��Ƶ�ͨ�˲���
    Fs=200;
    fp1=40;fs1=50;rs=30;rp=0.5;
    wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %ͨ���߽�Ƶ��
    ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %����߽�Ƶ��
    [n,wn]=buttord(wp,ws,rp,rs,'s'); %�˲����Ľ���n��-3dB��һ����ֹƵ��Wn
    [b,a]=butter(n,wn,'s');
    [num,den]=bilinear(b,a,Fs);  %˫���Ա任
    I=filter(num,den,I);
    Q=filter(num,den,Q);
    [h,w]=freqz(num,den,100,Fs);
%     figure(1)
%     subplot(4,1,1);
%     plot(w,abs(h));
%     xlabel('Ƶ��/Hz');
%     ylabel('��ֵ');
%     title('������˹��ͨ�˲�����������');
%     grid on;
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
Fs=1000;
fp1=25;fs1=40;rs=30;rp=0.5;
wp=2*Fs*tan(2*pi*fp1/(2*Fs)); %ͨ���߽�Ƶ��
ws=2*Fs*tan(2*pi*fs1/(2*Fs)); %����߽�Ƶ��
[n,wn]=buttord(wp,ws,rp,rs,'s'); %�˲����Ľ���n��-3dB��һ����ֹƵ��Wn
[b,a]=butter(n,wn,'s');
[num,den]=bilinear(b,a,Fs);  %˫���Ա任
y_fsk = zeros(4, length(x_fsk));
for iter = 1 : symbols
    y = x_fsk(1, (iter-1)*length(t1)+1:iter*length(t1));
    y_len = length(y);
    detect = zeros(1,y_len);         % Ԥ�ü���ź�
    distance = zeros(1,M);              % �����������
    for j = 1 : M
        y_ = y.*sin(j*w_fsk*t1);       
        y_=filter(num,den,y_);
        [h,w]=freqz(num,den,100,Fs);
        distance(j) = mean(abs(y_));        
    end
    for i = 1 : y_len                
        pos = find(distance == max(distance)); % ����о�
        detect(i) = pos(1) - 1; % �����ķ��ţ�ʮ���ƣ�
        y_fsk(:, i+(iter-1)*y_len) = (dec2bin(detect(i), 4) - '0')';
    end
    

    detect(y_len);
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



























