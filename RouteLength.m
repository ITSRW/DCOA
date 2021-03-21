function L=RouteLength(route,dist)
    n=length(route);
    route=[route route(1)];
%     route=[route];
    L=0;
    for k=1:n 
        i=route(k);
        j=route(k+1); 
        L=L+dist(i,j);%*111000; 
    end
end