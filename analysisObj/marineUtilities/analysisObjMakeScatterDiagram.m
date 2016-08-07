function [objScat] = analysisObjMakeScatterDiagram(obj1,obj2,varargin)
% analysisObjMakeScatterDiagram - makes a scatter diagram (typical offshore use)
% (prob distribution) of the data. If the optional obj2scat is sent in it is
% distributed on the obj1 obj2 axis. 
% --- function call 
% [objScat] = analysisObjMakeScatterDiagram(obj1,obj2,[step1],[step2]);
% --- Input 
%   obj1,obj2       - the two analysisObject vectors to be put into a scatter diagram
%   step1,step2     - delta value (constant) for the two axis (optional, standard = 0.5)
%
% - Output - struct with the following data
%    dat        - scatter table
%    xAxis      - scatter Y axis
%    yAxis      - scatter X axis
%    parameter  - description of parameters that is scattered
%    location   - where the scatter diagram is valid
%    source     - data sources
%    table4expor- a complete scatter diagram table with cdf and pdf ready to import in excel 
% Rev 1.0 & 2012-01-20
% Programmed by: Dr. Karl Chr. Strømsem, OffTek AS

% initialize
step1= 0.5;
step2= 0.5;
if  nargin == 4;
    step1= varargin{1};
    step2= varargin{2};
end

% set working data
X = obj1.data.dat(:);
Y = obj2.data.dat(:);

%create classes
x = round(min(X)):step1:(round(max(X))+step1);
y = round(min(Y)):step2:(round(max(Y))+step2);
XL = length(X);
YL = length(Y);
xl = length(x);
yl = length(y);

% Identify in which class the data belongs, i.e. create location matrix'
IX = repmat(X,1,xl-1)-repmat(x(2:end),XL,1) <0 & repmat(X,1,xl-1)-repmat(x(2:end),XL,1) >= -step1;
IY = repmat(Y,1,yl-1)-repmat(y(2:end),YL,1) <0 & repmat(Y,1,yl-1)-repmat(y(2:end),YL,1) >= -step2;

% recast to ones
IIX = ones(size(IX)).*IX;
IIY = ones(size(IY)).*IY;

% create Scatter diagram
objScat.dat     = IIX'*IIY;
objScat.xAxis   = x(2:end);
objScat.yAxis   = y(2:end);
objScat.parameter{1}= obj1.parameter;
objScat.parameter{2}= obj2.parameter;
objScat.location{1} = obj1.location;
objScat.location{2} = obj2.location;
objScat.source{1}   = obj1.source;
objScat.source{2}   = obj2.source;

% create scatterdiagram for exporting directly to excel with distribuions
% and sums 

dat = objScat.dat;
% create sum, pdf and cdf for vertical and horisontal directions
sdfT = sum(dat);
pdfT = sdfT/sum(sdfT);
cdfT = cumsum(pdfT);

sdfH = sum(dat')';
pdfH = sdfH/sum(sdfH);
cdfH = cumsum(pdfH);

nStates = sum(sdfH);

[nc, nl] = size(dat);
nc = nc +1;
nl = nl +1;

% modify and put all together into one exportable table
mtx = ones(nc,nl)*NaN;
mtx(2:nc,2:nl) = objScat.dat;

mtx(2:nc,1) = objScat.xAxis';
mtx(2:nc,end+1) = sdfH;
mtx(2:nc,end+1) = pdfH;
mtx(2:nc,end+1) = cdfH;

mtx(1,2:nl) = objScat.yAxis;
mtx(end+1,2:nl) = sdfT;
mtx(end+1,2:nl) = cdfT;
mtx(end+1,2:nl) = pdfT;

mtx(nc+1,nl+1)  = nStates;

objScat.table4export = mtx;