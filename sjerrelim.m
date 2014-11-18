function [ r,allrad ] = sjerrelim( nnr,errval,remdistortion )

s=size(errval);
n=s(1);
m=s(2);
calr=errval(1,:);
N=length(nnr);
ss=csvread('ss.csv');

%finding the coefficients
for i=2:n;
    rta=(errval(i,2)-errval(i,1))/(calr(1,2)-calr(1,1));
    rtb=(errval(i,3)-errval(i,1))/(calr(1,3)-calr(1,1));
    a=(rtb-rta)/(calr(1,3)-calr(1,2));
    b=rta-(a*(calr(1,2)+calr(1,1)));
    c=errval(i,1)-(b*calr(1,1))-(a*calr(1,1)*calr(1,1));
    coeff(i-1,1)=a;
    coeff(i-1,2)=b;
    coeff(i-1,3)=c;
end

r=nnr;

for j=1:20;
for i=1:N;
    esterr(i)=(coeff(i,1)*r(i)*r(i))+(coeff(i,2)*r(i))+coeff(i,3);
    r(i)=nnr(i)-esterr(i);
end
end

esterr=esterr';

for i=1:N;
    for j=1:ss(i,1);
        allrad(j,i)=r(i)+remdistortion(j,i);
    end
end


end

