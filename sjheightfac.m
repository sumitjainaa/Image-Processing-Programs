function [nh,htfac] = sjheightfac( controlxy,actheight )

%read parameters
fl=fopen('slaunch.txt');
tline=fgetl(fl);
par=fscanf(fl,'%f');
fclose(fl);
N=par(2);
np=2*N;

%calculating height
topxd=controlxy(1:2:np,2,1);
topyd=controlxy(1:2:np,2,2);
bxd=controlxy(2:2:np,2,1);
byd=controlxy(2:2:np,2,2);

h=byd-topyd;

%calculating error in height
avght=mean(h);
htfac=((avght-actheight)*100)/actheight;
fac=1+(htfac/100);

%height after error subtraction
nh=h/fac;

end

