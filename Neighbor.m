function route2=Neighbor(route1,pSwap,pReversion,pInsertion,track)
    index=Roulette(pSwap,pReversion,pInsertion);
    if index==1
        route2=Swap(route1,track);
    elseif index==2
        route2=Reversion(route1,track);
    else
        route2=Insertion(route1,track);
    end
end
