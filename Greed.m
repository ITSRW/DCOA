function solution=Greed(dist)
    %�ź�
    number=1:1:size(dist,1);
    dist=[number;dist];
    for index=2:size(dist,2)+1
        dist(index,index-1)=inf;
    end
    
    %������ʼ�㣬
    lastpoint=ceil(rand()*size(dist,1));
    solution=[lastpoint];
    
    for index=2:1:size(dist,1)-1
        %�رյ�ǰ�����
        dist(:,dist(1,:)==lastpoint)=[];
        %�ҳ���һ��̰����
        mindist=min(dist(lastpoint+1,:));  
        lastpoint=dist(1,dist(lastpoint+1,:)==mindist);
        lastpoint=lastpoint(1);
        %��¼��һ����
        solution=[solution,lastpoint];
    end
    
end