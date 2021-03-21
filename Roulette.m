function index=Roulette(pSwap,pReversion,pInsertion)
p=[pSwap pReversion pInsertion];
r=rand;
c=cumsum(p);
index=find(r<=c,1,'first');
end