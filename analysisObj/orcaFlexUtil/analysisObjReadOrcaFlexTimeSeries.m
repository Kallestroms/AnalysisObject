model2analyse = input('Input OrcaFlex Model Simulation file name: ','s');
[fpth fname fxt] = fileparts(model2analyse);

if isempty(fxt);
    fnm = [fname, '.sim'];
else
    fnm = [fname, fxt];
end

model2analyse = fnm;

[objOut] = analysisObjReadOrcaFlexSimFileInfo(fnm);


iVar = 0;

dumObj = analysisObjCreate([]);
dumObj.source = fname;
dumObj.type = 'Orcaflex simulation time series';
isName = strcmpi(objOut.info.objName,'General');
isPar = strcmpi(objOut.info.objVars{isName},'Time');
dumObj.data.time = objOut.model(objOut.info.objName{isName}).TimeHistory(objOut.info.objVars{isName}{isPar})';

isFinished = 0;

while ~isFinished;
    
    try       
        isName = menu('Select Element',objOut.info.objName);
        isPar = menu(sprintf('Extract %s',objOut.info.objName{isName}),objOut.info.objVars{isName});
        
        
        iVar = iVar+1;
        ofxObj(iVar) = dumObj;
        ofxObj(iVar).data.dat   = objOut.model(objOut.info.objName{isName}).TimeHistory(objOut.info.objVars{isName}{isPar})';
        ofxObj(iVar).object     = objOut.info.objName{isName};
        ofxObj(iVar).parameter  = objOut.info.objVars{isName}{isPar};
        analysisObjPlot(ofxObj(iVar));
        pause
    catch err
        error(err.message);
    end
    
    isFinished = menu('Extracted necessary data',{'Yes','No'}) ==1;
    
end

