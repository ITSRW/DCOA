function solution=Greed(dist)
    number=1:1:size(dist,1);
    dist=[number;dist];
    for index=2:size(dist,2)+1
        dist(index,index-1)=inf;
    end
    
    lastpoint=ceil(rand()*size(dist,1));
    solution=[lastpoint];
    
    for index=2:1:size(dist,1)-1
        dist(:,dist(1,:)==lastpoint)=[];
        mindist=min(dist(lastpoint+1,:));  
        lastpoint=dist(1,dist(lastpoint+1,:)==mindist);
        lastpoint=lastpoint(1);
        solution=[solution,lastpoint];
    end
    
end
