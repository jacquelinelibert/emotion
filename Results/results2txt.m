fileID = fopen('summaryResults.txt','wt');
fprintf(fileID,'ppID\tphase\tacc\tRT \n');
cd('C:\Users\Jacqueline Libert\Documents\BCN\Major Project\Results\Emotion');
files = dir('*.mat');
nFiles = length(files);
for ifiles = 1:nFiles
    load(files(ifiles).name);
    [~, startIndex] = regexp(files(ifiles).name,'emo_');
    [endIndex, ~] = regexp(files(ifiles).name,'.mat');
    ppID = files(ifiles).name(startIndex+1 : endIndex-1);
    % phases = fieldnames(resp);
    % nPhases = length(phases);
    % for iphase = 1 : nPhases
    itrial = 1:options.(phase).total_ntrials; 
        nResponses = length(resp.(itrial).response);
        for iresponse = 1 : nResponses
            nAttempts = length(results.(phases{iphase}).conditions(iresponse).att);
            for iAttempt = 1 : nAttempts                
                fprintf(fileID,'%s\t', ppID);
                fprintf(fileID,'%s\t', phases{iphase});
                fprintf(fileID,'%1.2f\t', ...
                    sum([results.(phases{iphase}).conditions(iresponse).att(iAttempt).responses.correct]) / ...
                    length(results.(phases{iphase}).conditions(iresponse).att(iAttempt).responses));
                fprintf(fileID,'%2.2f\t', ...
                    mean([results.(phases{iphase}).conditions(iresponse).att(iAttempt).responses.response_time]));
%                 fprintf(fileID,'%2.2f ', ...
%                     results.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
%                 fprintf(fileID,'%2.2f ', ...
%                     results.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
%                 fprintf(fileID,'%2.2f ', ...
%                     results.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
                fprintf(fileID,'\n');
            end
        end
    %end
%    fprintf(fileID,'%s\n',C{row,:});
end

fclose(fileID);