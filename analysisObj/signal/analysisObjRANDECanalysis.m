function [res]=analysisObjRANDECanalysis(ts,wind,dt,nz,ti)

%function [res]=analysisObjRANDECanalysis(ts,wind,dt,nz,ti)
% Function to randec analyse a time series and return the results
%
% [res]=analysisObjRANDECanalysis(ts,wind,dt,nz,ti)  (title argument ti is optional)
%
% Input :
% ts    - analysis object dimension 1 to be analysed. 
% wind  - window for randec analysis in seconds shold at leas be 10 times expected natural period
% dt    - sampling period sec between points
% nz	- number of zero crossings for response fitting
%

try
    source = ts(1).source;
catch
    source = '';
end

ts = ts(1).data.dat;
nts=length(ts);    % number of points in time series
nrs=fix(wind/dt);  % number of points for establishing random decrement signature

% check for NaN in data and remove if present
ts  = ts(~isnan(ts));

% Eatablishes the random decrement signature
[rds resData]=randresp(ts,nrs,nts);
t=(1:wind)*dt;

%plot(t,rds(1:wind));xlabel('Time');ylabel('Respons');title('Random decrement signature');pause;

% calculate natural periods damping and standard error 
[td,ksi,qc,y,t]=randdamp(rds,dt,nz);

% Plot results

res=[td ksi qc];
%t=(0:dt:td*nz)';
%nt=max(size(t));
lt=(1:max(size(t)))';
figure;plot(t,y,t,rds(lt));grid

if nargin<5;
   str=sprintf('RD signature and fitted response for %s',source);
else
   str=sprintf('%s RD signature and fitted response for %s',ti,source);
end

title(str);xlabel('Time ');ylabel('Motion');
xy=axis;xx=xy(1)+.5*(xy(2)-xy(1));yy=xy(3)+.8*(xy(4)-xy(3));
s=sprintf('Natural period %8.2f\nDamping ratio %6.4f\nStandard error %6.4f\n',td,ksi,qc);
text(xx,yy,s);
% ##############################################
% RANDRESP function called by analysisObjRANDECanalysis
% ##############################################

function [rs resData]=randresp(ts,nrs,nts);
%
% copyright r. jefferys, r&d, conoco(uk) ltd june 1986
% modified from fortran code to matlab code K.C. Str?msem OffTek as, Norway, 30 Oct. 1997.
% this routine extracts the initial condition response from a random
% signal
%
% input variables
%
% ts  - contains the time series
% nrs - number of response points to consider
% nts - is the number of data points in the time series
% 
% 
% ouput variables
%
% rs - the random decrement signature
%
% in is .true. if abs(time series) < rms else .false.

%
%
% zero mean and find rms
%

rs=zeros(nrs,1);
navg=0;
ts=ts(:);

% zerom signal

tsbar=mean(ts);
ts=(ts)-tsbar;
rms=std(ts);


if abs(ts(1))< rms
   in=1;
else
   in=0;
end


for k=1:nts-nrs;
   kp1=k+1;
       if  in ~= (abs(ts(kp1)) < rms)
%
% crossing detected
%
        in=~in;
        navg=navg+1;
        
        if ts(k) == ts(kp1)
           a=1.;
           b=0.;
        elseif ts(k)> 0.           
           a=(rms-ts(k))/(ts(kp1)-ts(k));
           b=1.-a;
        else           
           a=(rms+ts(k))/(ts(kp1)-ts(k));
           b=-1.-a;
        end        
           rs=rs+b*ts((1:nrs)+k-1)+a*ts((1:nrs)+k);
     end      
  end
  
  fac=navg*rms;
  rs=rs/fac;
  
  resData=sprintf(' mean value:  %.5f \n rms:  %.5f \n number of averages to generate response:  %6i',tsbar,rms,navg);
  %disp(s);
  
% ##############################################
% RANDDAMP function called by analysisObjRANDECanalysis
% ##############################################
function [td,ksi,qc,y,t]=randdamp(rds,dt,nz);
%
% input values
%  rds - random decrement signature
%  dt  - time step
%  nz - number of zero crossings to be used in analysis
%
% output variables
%
%  td    - damped natural period
%  ksi   - estimated damping value in ratio of critical
%  y     - decay curve from fitted data
%  qc    - lsq error estimated between decay curve and actual curve. 
%  t     - generated time axis
np=(1:nz)';

% find zero crossings, peaks and periods where this happens
[tz,tp,pz,pk,pp]=tzpk(rds,dt);


% calculate mean peak and mean zero up cross half periods and check for consistency
tpk=mean(tp(np));tzr=mean(tz(np));
if abs(tpk/tzr-1.0) > 0.05 
   s=sprintf('Half periods tpk %4.4f and tpz %4.4f are not consistent ', tpk, tzr);
   disp(s);
end

% find damped natural period and log decrement damping
td=tpk+tzr;
wd=2*pi/td;
lny=log(pk(np));
delta=-np\lny;

% display the results of the zero crossings findings
s=sprintf(' Tz/2[s]  Tp/2[s]     Peaks    log(peak)');
disp(s);disp([cumsum(tz(np)) cumsum(tp(np)) pk(np) lny]);

% calculate fraction of critical damping ksi=c/ccr = d/pi and correct once for undamped natural period
ksi=delta/pi;
wn=wd/sqrt(1-ksi.^2);
ksi=delta*(1-ksi.^2)/(pi);

% establish the decay curve

t=(0:dt:td*nz)';
nt=min([max(size(t)) max(size(rds))]); 
lt=(1:nt)';
t=t(lt);

y=1.0*exp(-ksi*wn*t).*real(exp(-i*wd*t));

% calculate the lsq error between fitted decay curve and random decrement signature
% qc=sqrt((rds(lt)-y).^2./y.^2);
qc=1-rds(lt)\y; % performes a lsq fit to the data and is 1 if perfect and 0 if no fit at all

% ##############################################
% tztp function called by RANDDAMP
% ##############################################

function [tz,tp,pz,pk,pp]=tzpk(ts,dt);
% function [tz,tp,pz,pk,pp]=tzpk(ts,dt);
%
% Input values 
% ts: time series
% dt: time step
%
% Ouput values
% tz - vector of half period zero crossings
% tp - vector of time instants for (absolute value peaks)
% pk - vector of (absolute value )peaks
% pz - vector of positions in time series of zero crossings
% pp - vector of positions in time series of (absolute vaue) peak's

ts=ts(:);l=2:max(size(ts));

%dts=diff(ts);
%ddts=diff(ts,2);

% find zero crossings

pz=find(ts(l).*ts(l-1)<0);
nz=max(size(pz));

tz=(pz(2:(nz))-pz(1:nz-1))*dt;
% nz=fix(nz/2)*2;

pk=zeros(nz,1);
pp=[];

ts=abs(ts);

%lpk=1:pz(1);
%pk(1)=max(ts(lpk));
%pp=[pp pz(1)+find(pk(1)==ts(lpk))];

for ii=1:nz-1
   lpk=pz(ii):pz(ii+1);
   pk(ii)=max(ts(lpk));   
%   lpk=find(pk(ii)==ts(lpk))
   pp=[pp pz(ii)+find(pk(ii)==ts(lpk))];
end
pp=pp';
tp=[pp(1) pp(2:nz-1)'-pp(1:nz-2)']'*dt;
%tp=pp*dt;