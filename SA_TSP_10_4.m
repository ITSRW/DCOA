clc;
clear;
close all;
%% ��������
vertexs=csvread('pointdata\pcb442.csv');
x=vertexs(:,1)';
y=vertexs(:,2)';

n=length(x);                    %������Ŀ
h=pdist(vertexs);
dist=squareform(h);             %�������

currRoute=Greed(dist);          %

%% ����
MaxOutIter=1000;                     %���ѭ������������
MaxInIter=1000;                       %���ѭ������������
T0=0.001;                           %��ʼ�¶�
alpha=0.998;                         %��ȴ����
pSwap=0.1;                          %ѡ�񽻻��ṹ�ĸ���
pReversion=0.45;                     %ѡ����ת�ṹ�ĸ���
pInsertion=1-pSwap-pReversion;      %ѡ�����ṹ�ĸ���
xl=1.0;                             %�����ʼxֵ
yl=1.0;                             %�����ʼyֵ
zl=1.0;                             %�����ʼzֵ
yita=T0*0.9+1;                          %��������

%% ��ʼ��
% currRoute=randperm(n);              %��������ʼ��


% PlotRoute(currRoute,x,y);

currL=RouteLength(currRoute,dist);  %��ʼ���ܾ���
bestRoute=currRoute;                %��ʼ����ʼ�⸳ֵ��ȫ�����Ž�
bestL=currL;                        %��ʼ����ʼ���ܾ��븳ֵ��ȫ�����Ž��ܾ���
BestLOutIter=zeros(MaxOutIter,1);   %��¼���ѭ����ÿһ�����Ž���ܾ���
T=T0;                               %�¶ȳ�ʼ��

%% ����ģ���˻�������
tic
for outIter=1:MaxOutIter
    %��Ƭ��ɢ����������������ز�
    [mat,xl,yl,zl]=Chaos(xl,yl,zl,MaxInIter,n);
%%  ������������������һ�λ����ز��������˻�⣬�ý��п��ܸ��ţ��п��ܸ��
    for inIter=1:MaxInIter
%         mat=[mat,int32(ceil(rand(1)*n))];
        newRoute=Neighbor(currRoute,pSwap,pReversion,pInsertion,mat(:,inIter));       %��������ṹ��������µ�·��
%         newRoute=Neighbor(currRoute,pSwap,pReversion,pInsertion,mat);       %��������ṹ��������µ�·��
        newL=RouteLength(newRoute,dist);                                %��·�ߵ��ܾ���
        %�����·�߱ȵ�ǰ·�߸��ã�����µ�ǰ·�ߣ��Լ���ǰ·���ܾ���
       %% ��ʤ��ֱ�Ӳ���
        if newL<=currL 
            currRoute=newRoute; 
            currL=newL;
       %% �ӽ���ɷ���-�˻���ܸ���
        else 
            %�����·�߲��統ǰ·�ߺã�������˻�׼����һ�����ʽ�����·��
            delta=(newL-currL)/currL;           %������·���뵱ǰ·���ܾ������İٷֱ�
            P=exp(-delta/T);                    %���������·�ߵĸ���
            %���0~1�������С��P���������·�ߣ������µ�ǰ·�ߣ��Լ���ǰ·���ܾ���
            if rand<=P
                currRoute=newRoute; 
                currL=newL;
            end
        end
    end
    
    %% �񵴻����˻��
    if currL<bestL*yita
        bestRoute=currRoute;
        bestL=currL;
        yita=(yita-1)*0.99+1;
    else
        yita=(yita-1)*1.5+1;
    end
    
    %��¼���ѭ��ÿ�ε�����ȫ������·�ߵ��ܾ���
    BestLOutIter(outIter)=bestL;
    %��ʾ���ѭ��ÿ�ε�������ȫ������·�ߵ��ܾ���
    disp(['��' num2str(outIter) '�ε�����ȫ������·���ܾ��� = ' num2str(BestLOutIter(outIter))]);
    %���µ�ǰ�¶�
    T=alpha*T;
    %�������ѭ��ÿ�ε�����ȫ������·��ͼ
    figure(1);
    PlotRoute(bestRoute,x,y)
    pause(0.01);
end

toc
%% ��ӡ���ѭ��ÿ�ε�����ȫ������·�ߵ��ܾ���仯����ͼ
figure;
plot(BestLOutIter,'LineWidth',1);
xlabel('��������');
ylabel('����');