function y_fsk = demodulate_16fsk2(x_fsk, fs, fc, smooth)
% demodulate_16fsk1 ���ڶ�16fsk�źŽ��з���ɽ��
% x_fsk: 16fsk�����ź�; fs: ������; fc: �ز�Ƶ��; smooth: ������Ԫ����

Fs = smooth;
M = 16;
spf = zeros(M, length(x_fsk));
for i = 1 :M
    % ��ͨ�˲�
    fpass = fc*i - fc*0.3;
    fstop = fc*i + fc*0.3;
    spf(i, :) = IdealFilter(x_fsk, Fs, fpass, fstop);
    
    %ȫ������
    spf(i, :) = abs(spf(i, :));

    %��ͨ�˲�
    fpass = fc-fc/2;
    fstop = fc+fc*0.2;
    spf(i, :) = IdealFilter(spf(i, :), Fs, fpass, fstop);
end

% ����о�
y_fsk = zeros(4, length(x_fsk));

for i = 1 : length(x_fsk)/smooth
    %����о�
    distance = spf(:, (i-1)*smooth+1:i*smooth);
    num = zeros(1, M);
    for j = 1 : smooth
        pos = find(distance(:, j) == max(distance(:, j)));
        detect = pos(1); % �����ķ��ţ�ʮ���ƣ�
        
        num(1, detect) = num(1, detect)+1;
    end
    pos = find(num == max(num));
    detect = pos(1) - 1; % �����ķ��ţ�ʮ���ƣ�
    y_fsk(:, i*smooth) = (dec2bin(detect, 4) - '0')';   
end

end

