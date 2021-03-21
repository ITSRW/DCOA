%输入route：           路线
%输入x,y：             x,y坐标
function PlotRoute(route,x,y)
route=[route route(1)];
% route=[route];
plot(x(route),y(route),'marker','.');
xlabel('x');
ylabel('y');
end