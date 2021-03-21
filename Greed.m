function solution=Greed(dist)
    %排号
    number=1:1:size(dist,1);
    dist=[number;dist];
    for index=2:size(dist,2)+1
        dist(index,index-1)=inf;
    end
    
    %生成起始点，
    lastpoint=ceil(rand()*size(dist,1));
    solution=[lastpoint];
    
    for index=2:1:size(dist,1)-1
        %关闭当前点入度
        dist(:,dist(1,:)==lastpoint)=[];
        %找出下一个贪婪点
        mindist=min(dist(lastpoint+1,:));  
        lastpoint=dist(1,dist(lastpoint+1,:)==mindist);
        lastpoint=lastpoint(1);
        %记录下一个点
        solution=[solution,lastpoint];
    end
    
end