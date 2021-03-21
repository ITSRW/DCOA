clear;
clc;
x=3.0;
y=3.0;
z=3.0;
figure(1)

b=1;
T=10000;
for index=1:1:1
    [mat,x,y,z]=newCHaos(x,y,z,T,b);
    figure(1)
    toone=zeros(T,3);
    for i=1:1:size(mat,1)
        toone(i,1)=(mat(i,1)-min(mat(:,1)))/(max(mat(:,1))-min(mat(:,1)));
        toone(i,2)=(mat(i,2)-min(mat(:,2)))/(max(mat(:,2))-min(mat(:,2)));
        toone(i,3)=(mat(i,3)-min(mat(:,3)))/(max(mat(:,3))-min(mat(:,3)));
    end
    plot(toone(:,1),toone(:,3));
    %     plot3(mat(:,1),mat(:,2),mat(:,3));
    %     pause(0.01);
    b=b+0.1;
    disp(b);
    % figure
    % comet3(mat(:,1),mat(:,2),mat(:,3));
    
    
    % s=[];
    % for i=1:10000
    %     seq=randperm(78);
    %     I=seq(1:2);
    %     s=[s;I];
    % end
end