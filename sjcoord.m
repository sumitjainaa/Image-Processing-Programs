function [x,y,z] = sjcoord(allrad,ydist)

%read the parameters
fl=fopen('slaunch.txt');
tline=fgetl(fl);
par=fscanf(fl,'%f');
fclose(fl);
N=par(2);
angl=(6.28318*(N-1))/N;
ang=linspace(0,angl,N)';
s=csvread('ss.csv');
[hnumb,indhnumb]=max(s);
coord=[];

i=indhnumb(1);
l=s(i,1);
for j=1:l;
    rco(j,i)=allrad(j,i);
    xco(j)=(rco(j,i))*(cos((ang(i))));
    yco(j)=ydist{1,i}(j);
    zco(j)=(rco(j,i))*(sin((ang(i))));
end
x(:,i)=xco(:);
y(:,i)=yco(:);
z(:,i)=zco(:);

for i=1:90;
    l=s(i,1);
    for j=1:l;
        rco(j,i)=allrad(j,i);
        xco(j)=(rco(j,i))*(cos((ang(i))));
        yco(j)=ydist{1,i}(j);
        zco(j)=(rco(j,i))*(sin((ang(i))));
    end
    for k=l+1:hnumb;
        xco(k)=xco(l);
        yco(k)=yco(l);
        zco(k)=zco(l);
    end
    xcoeff=polyfit(yco,xco,3);
    zcoeff=polyfit(yco,zco,3);
    for k=1:hnumb;
        yco(k)=y(k,indhnumb(1));
        xco(k)=xcoeff(4)+(xcoeff(3)*yco(k))+(xcoeff(2)*(yco(k)^2))+(xcoeff(1)*(yco(k)^3));
        zco(k)=zcoeff(4)+(zcoeff(3)*yco(k))+(zcoeff(2)*(yco(k)^2))+(zcoeff(1)*(yco(k)^3));
    end
    x(:,i)=xco(:);
    y(:,i)=yco(:);
    z(:,i)=zco(:);
end

x(:,91)=x(:,1);
y(:,91)=y(:,1);
z(:,91)=z(:,1);
end

