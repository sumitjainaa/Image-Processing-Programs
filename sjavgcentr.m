function [xshift, yshift, nnr ] = sjavgcentr(nr, N)

angl=(6.28318*(N-1))/N;
ang=linspace(0,angl,N)';

%finding the centroid by average method
nnr=nr;

    for i=1:N
        xco(i)=(nnr(i))*(cos((ang(i))));
        yco(i)=(nnr(i))*(sin((ang(i))));
    end
    xco=xco';
    yco=yco';
    xsum=sum(xco);
    xshift=xsum/N;
    ysum=sum(yco);
    yshift=ysum/N;
    
    for i=1:N
        nxco(i)=xco(i)-xshift;
        nyco(i)=yco(i)-yshift;
        nnr(i)=sqrt((nxco(i)*nxco(i))+(nyco(i)*nyco(i)));
    end
    

end

