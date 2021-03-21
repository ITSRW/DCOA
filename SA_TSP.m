clc;
clear;
close all;
minsolu=[];
%% 输入数据
vertexs=csvread('pointdata\pcb442.csv');
x=vertexs(:,1)';
y=vertexs(:,2)';

n=length(x);                    %城市数目
h=pdist(vertexs);
dist=squareform(h);             %距离矩阵
%% 参数
MaxOutIter=1000;                     %外层循环最大迭代次数
MaxInIter=5000;                       %里层循环最大迭代次数
T0=0.0015;                           %初始温度
alpha=0.992;                         %冷却因子
pSwap=0.33;                          %选择交换结构的概率
pReversion=0.33;                     %选择逆转结构的概率
pInsertion=1-pSwap-pReversion;      %选择插入结构的概率
xl=1+unifrnd(-0.1,0.1);                             %混沌初始x值
yl=1+unifrnd(-0.1,0.1);                             %混沌初始y值
zl=1+unifrnd(-0.1,0.1);                             %混沌初始z值
yita=1;                          %初始振荡率
quake=0.01;                         %膨胀-收缩力度

logyita=[];
logT=[];
currentbestroute=[];
%% 初始化
% currRoute=randperm(n);              %随机构造初始解

currRoute=Greed(dist);
% PlotRoute(currRoute,x,y);

currL=RouteLength(currRoute,dist);  %初始解总距离
bestRoute=zeros(MaxOutIter+1,size(currRoute,2));
bestRoute(1,:)=currRoute;                %初始将初始解赋值给全局最优解
bestL=currL;                        %初始将初始解总距离赋值给全局最优解总距离
BestLOutIter=zeros(MaxOutIter,1);   %记录外层循环的每一代最优解的总距离
T=T0;                               %温度初始化

%% 混沌模拟退火主迭代
tic
for outIter=1:MaxOutIter
    %分片离散化混沌搜索轨道重载波
    [mat,xl,yl,zl]=Chaos(xl,yl,zl,MaxInIter,n);
    %%  混沌邻域搜索：产生一次混沌载波搜索的退火解，该解有可能更优，有可能更差。
    for inIter=1:MaxInIter
        %         mat=[mat,int32(ceil(rand(1)*n))];
        newRoute=Neighbor(currRoute,pSwap,pReversion,pInsertion,mat(:,inIter));       %经过邻域结构后产生的新的路线
        %         newRoute=Neighbor(currRoute,pSwap,pReversion,pInsertion,mat);       %经过邻域结构后产生的新的路线
        newL=RouteLength(newRoute,dist);                                %该路线的总距离
        %如果新路线比当前路线更好，则更新当前路线，以及当前路线总距离
        %% 优胜解直接采纳
        if newL<=currL
            currRoute=newRoute;
            currL=newL;
            %% 劣解采纳法则-退火接受概率
        else
            %如果新路线不如当前路线好，则采用退火准则，以一定概率接受新路线
            delta=(newL-currL)/currL;           %计算新路线与当前路线总距离相差的百分比
            P=exp(-delta/T);                    %计算接受新路线的概率
            %如果0~1的随机数小于P，则接受新路线，并更新当前路线，以及当前路线总距离
            if rand<=P  %考虑如何添加自适应的升温策略
                currRoute=newRoute;
                currL=newL;
            end
        end
    end
    
    %% 振荡混沌退火解
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

    %记录外层循环每次迭代的全局最优路线的总距离
    BestLOutIter(outIter)=bestL;
    logyita(outIter)=yita;
    logT(outIter)=T;
    
    %显示外层循环每次迭代的信全局最优路线的总距离
    disp(['第' num2str(outIter) '次迭代满意解路线总距离 = ' num2str(BestLOutIter(outIter))]);
    toc
    %更新当前温度
    T=alpha*T;
    
    %画出外层循环每次迭代的全局最优路线图
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
%% 打印外层循环每次迭代的全局最优路线的总距离变化趋势图
figure(2);
plot(BestLOutIter,'LineWidth',1);
hold on
plot(minsolu,'-.','LineWidth',1);
xlabel('迭代次数');
ylabel('距离');


