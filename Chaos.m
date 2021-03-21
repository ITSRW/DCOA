function [track,x0,y0,z0]=Chaos(x,y,z,Length,solutionsize)
    a=10;
    b=28;
    c=1;
    d=6.2;
    P=6;
    I=10^16;
    MOD = 10 ^ P;
    step=0.01;
    track=zeros(2,Length);
    x0=x;
    y0=y;
    z0=z;
    xl=x;
    yl=y;
    zl=z;
    for index =1:1:2

        %         s1=[];
        %         s2=[];
        %         s3=[];
        s=zeros(1,Length);
        for L=1:1:(Length+500)
            %         xl = xl + step * (a * (y0 - x0));
            %         yl = yl + step * (b * x0 - x0 * z0 - y0);
            %         zl = zl + step * (x0 *y0 - c * z0);
            xl = xl + step * (a * (y0 - x0));
            yl = yl + step * (b * x0 - x0 * z0 - c*y0);
            zl = zl + step * (x0^2 + sin(x0*y0)- d * z0);
            x0= xl;
            y0= yl;
            z0= zl;
            %             s1=[s1,x0];
            %             s2=[s2,y0];
            %             s3=[s3,z0];
            if L>500
                s(L-500)=mod(z0*I,MOD);
            end
        end
        track(index,:)=s;
    end
    track=int32(floor(track/MOD*solutionsize))+1;
end

