clc;
clear;
close all;
minsolu=[];
%% ��������
vertexs=csvread('pointdata\pcb442.csv');
x=vertexs(:,1)';
y=vertexs(:,2)';

n=length(x);                    %������Ŀ
h=pdist(vertexs);
dist=squareform(h);             %�������
%% ����
MaxOutIter=1000;                     %���ѭ������������
MaxInIter=5000;                       %���ѭ������������
T0=0.0015;                           %��ʼ�¶�
alpha=0.992;                         %��ȴ����
pSwap=0.33;                          %ѡ�񽻻��ṹ�ĸ���
pReversion=0.33;                     %ѡ����ת�ṹ�ĸ���
pInsertion=1-pSwap-pReversion;      %ѡ�����ṹ�ĸ���
xl=1+unifrnd(-0.1,0.1);                             %�����ʼxֵ
yl=1+unifrnd(-0.1,0.1);                             %�����ʼyֵ
zl=1+unifrnd(-0.1,0.1);                             %�����ʼzֵ
yita=1;                          %��ʼ����
quake=0.01;                         %����-��������

logyita=[];
logT=[];
currentbestroute=[];
%% ��ʼ��
% currRoute=randperm(n);              %��������ʼ��

currRoute=Greed(dist);
% PlotRoute(currRoute,x,y);

currL=RouteLength(currRoute,dist);  %��ʼ���ܾ���
bestRoute=zeros(MaxOutIter+1,size(currRoute,2));
bestRoute(1,:)=currRoute;                %��ʼ����ʼ�⸳ֵ��ȫ�����Ž�
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
            if rand<=P  %��������������Ӧ�����²���
                currRoute=newRoute;
                currL=newL;
            end
        end
    end
    
    %% �񵴻����˻��
    if (currL<bestL*(yita+1) && bestL~=currL) || outIter==1
        bestRoute(outIter+1,:)=currRoute;
        bestL=currL;
        yita=yita*(1-quake);
    else
        yita=yita+(1-yita)*T;
        T=T+(T0-T)*yita;
        if outIter==1
            bestRoute(outIter+1,:)=bestRoute(1,:);
        else
            bestRoute(outIter+1,:)=bestRoute(outIter-1,:);
        end
    end

    %��¼���ѭ��ÿ�ε�����ȫ������·�ߵ��ܾ���
    BestLOutIter(outIter)=bestL;
    logyita(outIter)=yita;
    logT(outIter)=T;
    
    %��ʾ���ѭ��ÿ�ε�������ȫ������·�ߵ��ܾ���
    disp(['��' num2str(outIter) '�ε��������·���ܾ��� = ' num2str(BestLOutIter(outIter))]);
    toc
    %���µ�ǰ�¶�
    T=alpha*T;
    
    %�������ѭ��ÿ�ε�����ȫ������·��ͼ
    minsolu=[minsolu;min(BestLOutIter(1:outIter))];
    
    bestlist=find(BestLOutIter(1:outIter)==min(BestLOutIter(1:outIter)));
    currentbestroute=bestRoute(bestlist(end),:);
    
    figure(1)
    subplot(2,2,1);
    plot(logyita(1:outIter));
    title('yita');
    subplot(2,2,2);
    plot(logT(1:outIter));
    title('T');
    subplot(2,2,3);
    PlotRoute(bestRoute(outIter,:),x,y);
    title('Current Solution');
    subplot(2,2,4);
    PlotRoute(currentbestroute,x,y);
    title('Best Solution');
    pause(0.01); 

    
end

toc
%% ��ӡ���ѭ��ÿ�ε�����ȫ������·�ߵ��ܾ���仯����ͼ
figure(2);
plot(BestLOutIter,'LineWidth',1);
hold on
plot(minsolu,'-.','LineWidth',1);
xlabel('��������');
ylabel('����');


