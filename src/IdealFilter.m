function y = IdealFilter(x, fs, fpass, fstop)
%IdealFilter ������ƴ�ͨ�˲���
%   x: �����ź�; fs: ������; fpass: ͨ����ʼƵ��; fstop: ͨ����ֹƵ��

fl = fpass;
fh = fstop;
wp=[fl/(fs/2) fh/(fs/2)];
N=128; 
b=fir1(N,wp,blackman(N+1)); 
y = filtfilt(b,1,x); 
end

