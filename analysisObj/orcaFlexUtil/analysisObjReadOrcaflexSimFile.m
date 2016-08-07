%    model2analyse = input('Input OrcaFlex Model Simulation file name: ','s');
function [ofxObj] = analysisObjReadOrcaflexSimFile(model2analyse)
% function [ofxObj] = analysisObjReadOrcaflexSimFile(model2analyse)
% The routine extracts all time series data from an Orcaflex simulation
% file and delivers back an analysisObject with the all the data.
%
% ### input
% model2analyse - orcaflex simulation file name
%
% ### output
% ofxObj - analysis object will all analysis data as separate objects
%

% Programmed by
% Dr. Karl Christian Strømsem
% OffTek AS, Norway

% Rev & date
% 1.0 2011-11-15

% Object types
% otGeneral: 1
% otEnvironment: 3
% otVessel: 5
% otLine: 6
% ot6DBuoy: 7
% ot3DBuoy: 8
% otWinch: 9
% otLink: 10
% otShape: 11
% otDragChain: 14
% otLineType: 15
% otClumpType: 16
% otWingType: 17
% otVesselType: 18
% otDragChainType: 19
% otFlexJointType: 20
% otStiffenerType: 21
% otFlexJoint: 41
% otAttachedBuoy: 43
% otBrowserGroup: 46
% otSolidFrictionCoefficients: 47
% otRayleighDampingCoefficients: 48
% otWakeModel: 49

%#### BEGIN
% check and define file name and create object for link to file
verbose = 1;
[fpth fname fxt] = fileparts(model2analyse);
if isempty(fxt);
    fnm = [fname, '.sim'];
else
    fnm = [fname, fxt];
end

model2analyse = fnm;
[objOut] = analysisObjReadOrcaFlexSimFileInfo(fnm);

% prepare analysisObjects extract time vector

dumObj = analysisObjCreate([]);
dumObj.source = fname;
dumObj.type = 'Orcaflex simulation time series';
isName = strcmpi(objOut.info.objName,'General');
isPar = strcmpi(objOut.info.objVars{isName},'Time');
dumObj.data.time = objOut.model(objOut.info.objName{isName}).TimeHistory(objOut.info.objVars{isName}{isPar})';

iVar = 0;
nObj = length(objOut.info.objName);

for isName = 2:nObj;
    try
        variableName    = objOut.info.objName{isName};
        variablePars    = objOut.info.objVars{isName};
        variableType    = objOut.info.objElem{isName};
        variableType    = variableType.type;
        if(verbose);disp(sprintf('Working on %s',variableName));end
        if ~isempty(variablePars);
            for isPar = 1:length(variablePars)
                if(verbose);disp(sprintf('Extracting  %s  time series',variablePars{isPar}));end
                iVar = iVar+1;
                ofxObj(iVar) = dumObj;
                ofxObj(iVar).data.dat   = objOut.model(objOut.info.objName{isName}).TimeHistory(objOut.info.objVars{isName}{isPar})';
                ofxObj(iVar).object     = objOut.info.objName{isName};
                ofxObj(iVar).parameter  = objOut.info.objVars{isName}{isPar};
            end
        elseif variableType == 6; % line element
            line = objOut.model(variableName);
            vars2extract = {'Effective Tension','Bend Moment','Shear Force','Max Von Mises Stress'};
            for iExt = 1:length(vars2extract);
                if(verbose);disp(sprintf('Extracting  %s  time series',vars2extract{iExt}));end
                iVar = iVar+1;
                ofxObj(iVar) = dumObj;
                ofxObj(iVar).data.dat   = line.TimeHistory(vars2extract{iExt}, ofx.oeEndA);
                ofxObj(iVar).object     = variableName;
                ofxObj(iVar).parameter  = sprintf('%s End A',vars2extract{iExt});
                iVar = iVar+1;
                ofxObj(iVar) = dumObj;
                ofxObj(iVar).data.dat   = line.TimeHistory(vars2extract{iExt}, ofx.oeEndB);
                ofxObj(iVar).object     = variableName;
                ofxObj(iVar).parameter  = sprintf('%s End B',vars2extract{iExt});
                iVar = iVar+1;
                ofxObj(iVar) = dumObj;
                ofxObj(iVar).data.dat   = line.RangeGraph(vars2extract{iExt});
                ofxObj(iVar).object     = variableName;
                ofxObj(iVar).parameter  = sprintf('%s Range Graph',vars2extract{iExt});
            end            
        else
            disp(sprintf('Object # %s #, not parsed',variableName));
        end
        
    catch err
        error(err.message);
    end
    
end
