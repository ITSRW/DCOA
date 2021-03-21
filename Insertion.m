function route2=Insertion(route1,track)
n=length(route1);
seq=randperm(n);
% I=seq(1:2);
% i1=min(I);
% i2=max(I);
i1=min(track);
i2=max(track);
% if i1<i2
    route2=route1([1:i1-1 i1+1:i2 i1 i2+1:end]);
% else
%     route2=route1([1:i2 i1 i2+1:i1-1 i1+1:end]);
% end
end