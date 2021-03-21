function route2=Reversion(route1,track)
n=length(route1);
% seq=randperm(n);
% I=seq(1:2);
% i1=min(I);
% i2=max(I);
i1=min(track);
i2=max(track);
route2=route1;
route2(i1:i2)=route1(i2:-1:i1);
end
