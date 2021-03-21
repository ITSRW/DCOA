function PlotRoute(route,x,y)
route=[route route(1)];
% route=[route];
plot(x(route),y(route),'marker','.');
xlabel('x');
ylabel('y');
end
