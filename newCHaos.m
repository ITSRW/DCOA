function [track,x0,y0,z0]=newCHaos(x,y,z,Length,e)
    a=10;
    b=28;
    c=1;
    d=2.5;
    P=6;
    I=10^16;
    MOD = 10 ^ P;
    step=0.01;
    track=[];
    s=[];
    x0=x;
    y0=y;
    z0=z;
    xl=x;
    yl=y;
    zl=z;
    for L=1:1:(Length+5)

        xl = xl + step * (a * (y0 - x0));
        yl = yl + step * (b * x0 - x0 * z0 - c*y0);
        zl = zl + step * (x0 *y0 - d * z0);
        
        
%         xl = xl + step * (a * (y0 - x0));
%         yl = yl + step * (b * x0 - x0 * z0 - c*y0);
%         zl = zl + step * (x0^2  + sin(x0)*cos(y0)- d * z0);
%         xl = xl + step * (a * (y0 - x0));
%         yl = yl + step * (b * x0 - x0 * z0 - c*y0);
%         zl = zl + step * (x0^2 + sin(x0*y0)- d * z0);
        
        x0= xl;
        y0= yl;
        z0= zl;
  
        if L>5
            s=[x0,y0,z0];
        end
        track=[track;s];
    end

end

