function route2=Neighbor(route1,pSwap,pReversion,pInsertion,track)
    index=Roulette(pSwap,pReversion,pInsertion);
    if index==1
        %�����ṹ
        route2=Swap(route1,track);
    elseif index==2
        %��ת�ṹ
        route2=Reversion(route1,track);
    else
        %����ṹ
        route2=Insertion(route1,track);
    end
end