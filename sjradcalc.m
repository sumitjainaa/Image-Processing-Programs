function [nnr, allrad, ydist, remdistortion] = sjradcalc(controlxy,cdist,incline)

%read the parameters
fl=fopen('slaunch.txt');
tline=fgetl(fl);
par=fscanf(fl,'%f');
fclose(fl);


s=csvread('ss.csv');
N=length(s);

xd=controlxy(:,:,1);
yd=controlxy(:,:,2);
a=1;

%finding the average
for i=1:N;
    b=a-1+s(i,1);
    xdist{i}=xd(a:b,2);
    ydist{i}=yd(a:b,2);
    a=b+1;
    sum=0;
    for j=1:s(i,1);
        sum=sum+xdist{1,i}(j);
    end
    avgx=sum/s(i,1);
    c(i)=avgx;
end
c=c';


%calculating inclination error
er(1:N,1:15)=0;
for i=1:N;
    for j=1:s(i,1);
        er(i,j)=xdist{1,i}(j)-c(i);
    end
end
er=er';


%estimating inclination error and remaining distortion or deformity
for i=1:N;
    for j=1:s(i,1);
        esterr(i,j)=(incline(1)*(ydist{1,i}(j)))+incline(2);
        remdistortion(j,i)=esterr(i,j)-er(j,i);
    end
end
esterr=esterr';


%subtracting inclination error
for i=1:N;
    for j=1:s(i,1);
        incxdist(j,i)=xdist{1,i}(j)-esterr(j,i);
    end
end

%finding the average again after inclination correction
for i=1:N;
    sum=0;
    for j=1:s(i,1);
        sum=sum+incxdist(j,i);
    end
    avgx=sum/s(i,1);
    c(i)=avgx;
end
c=c';


%measurinng radius
for i=1:N;
    r(i)=cdist-c(i);
end
r=r';


%finding the centroid and new radius(nnr)
angl=(6.28318*(N-1))/N;
ang=linspace(0,angl,N)';
[centroid,tcent,nr] = sjcentr(r, ang);
txshift=0;
tyshift=0;
nnr=nr;
for i=1:10;
    [xshift, yshift, nnr] = sjavgcentr(nnr, N);
    txshift=txshift+xshift;
    tyshift=tyshift+yshift;
end

%individual radius
for i=1:N;
    for j=1:s(i,1);
        allrad(j,i)=nnr(i)+remdistortion(j,i);
    end
end


end