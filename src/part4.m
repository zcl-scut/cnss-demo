%sigDm:������ź� pcm:���ڱȶԵ�pcm�� sigOriCut:ԭģ���źŽ�ȡ����һ��
function err=part4(sigDm,pcm,sigOriCut)
    sigRe=rebuild(sigDm,500);
    err=errorcnt(pcm,sigRe);
    
    sigDq=dquantization(sigRe);
    
    cutPoint=length(sigOriCut);
    t1=4:4:cutPoint;t2=1:cutPoint;
    sigIp=interp1(t1,sigDq,t2,'linear');
    figure;
    plot(t2,sigIp,t2,sigOriCut);

