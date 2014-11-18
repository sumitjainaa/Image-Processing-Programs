function [vol] = sjvolcalc(r,h)

vol=0;
m=length(h);
n=length(r);
ratio=n/m;

if ratio==1;
    for i=1:n;
        segvol=(3.1416*r(i)*r(i)*h(i))/n;
        ht=h(i);
        vol=vol+segvol;
    end
end

if ratio==2;
    j=1;
    for i=1:m-1;
        ht(j)=h(i);
        j=j+1;
        ht(j)=(h(i)+h(i+1))/2;
        j=j+1;
    end
    i=m;
    ht(j)=h(i);
    j=j+1;
    ht(j)=(h(i)+h(1))/2;
    for i=1:n;
        segvol=(3.1416*r(i)*r(i)*ht(i))/n;
        vol=vol+segvol;
    end
end
ht=ht';

end