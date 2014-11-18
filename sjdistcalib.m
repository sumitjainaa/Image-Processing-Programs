function [cdist,incline] = sjdistcalib(controlxy,actrad)

%read the parameters
fl=fopen('slaunch.txt');
tline=fgetl(fl);
par=fscanf(fl,'%f');
fclose(fl);

s=csvread('ss.csv');
N=par(2);

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

%calculating error
er(1:N,1:15)=0;
for i=1:N;
    for j=1:s(i,1);
        er(i,j)=xdist{1,i}(j)-c(i);
        end
end
er=er';


%inclination check
[hnumb,indhnumb]=max(s);
ypointh=ydist{1,indhnumb};
xpointh=xdist{1,indhnumb};
sumresxd(1:hnumb,1)=0;
numresyd(1:hnumb,1)=0;
for i=1:N;
    txdist=xdist{1,i};
    tydist=ydist{1,i};
    tsyp=size(txdist);
    for j=1:hnumb;
        resyp=find((tydist>(ypointh(j)-0.1))&(tydist<(ypointh(j)+0.1)));
        if resyp~=0;
            numresyd(j,1)=numresyd(j,1)+1;
            resxd=er(resyp(1),i);
            sumresxd(j,1)=sumresxd(j,1)+resxd;
        end
    end
end
for j=1:hnumb;
avgresxd(j,1)=sumresxd(j,1)/numresyd(j,1);
end

%slope and intercept using linear regression
incline=polyfit(ypointh,avgresxd,1);

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

%finding the average after inclination correction
for i=1:N;
    sum=0;
    for j=1:s(i,1);
        sum=sum+incxdist(j,i);
    end
    avgx=sum/s(i,1);
    c(i)=avgx;
end
c=c';

%rearranging the array
[small, ind]=min(c);
sc(1:N-ind+1)=c(ind:N);
sc(N-ind+2:N)=c(1:ind-1);

large = sc((N/2)+1);
gap = large-small;
aa = actrad + (gap/2);
bb = actrad - (gap/2);
cdist = small + aa;
dev = aa - actrad;
sc=sc';


%measurinng radius
for i=1:N;
    r(i)=cdist-sc(i);
end
r=r';

%finding the centroid
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

nrer=nnr-actrad;
avgnrer=mean(nrer);
cdist=cdist-avgnrer;

%minimizing the average error
for i=1:5
[ nnr, allrad, ydist, remdistortion ] = sjradcalc(controlxy,cdist,incline);
nrer=nnr-actrad;
avgnrer=mean(nrer);
cdist=cdist-avgnrer;
end

end