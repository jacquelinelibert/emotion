fileID = fopen('summaryresp.txt','wt');
fprintf(fileID,'ppID\tphase\tacc\tRT\tacc_C\tRT_C\tacc_I\tRT_I \n');
cd('C:\Users\Jacqueline Libert\Documents\BCN\Major Project\Results\Emotion');
files = dir('*.mat');
nFiles = length(files);
for ifiles = 1:nFiles
    load(files(ifiles).name);
    disp(files(ifiles).name)
    [~, startIndex] = regexp(files(ifiles).name,'emo_');
    [endIndex, ~] = regexp(files(ifiles).name,'.mat');
    ppID = files(ifiles).name(startIndex+1 : endIndex-1);
    phase = {'test'};
    nResponses = length(resp);
    if nResponses == options.training.total_ntrials
        phase = {'training'};
    end
    fprintf(fileID,'%s\t', ppID);
    fprintf(fileID,'%s\t', phase{:});
    acc = zeros(1, nResponses);
    RT = acc;
    congr = acc;
    for iResp = 1 : nResponses
        acc(iResp) = resp(iResp).response.correct;
        RT(iResp) = resp(iResp).response.response_time;
        congr(iResp) = resp(iResp).condition.congruent;
    end
%     congResp = sum(congr == 1);
%     notCongResp = sum(congr == 0);
    fprintf(fileID,'%1.2f\t', sum(acc) / nResponses);
    fprintf(fileID,'%2.2f\t', mean(RT));
    fprintf(fileID,'%1.2f\t', sum(acc(congr == 1)) / sum(congr == 1));
    fprintf(fileID,'%2.2f\t', mean(RT(congr == 1)));
    fprintf(fileID,'%1.2f\t', sum(acc(congr == 0)) / sum(congr == 0));
    fprintf(fileID,'%2.2f\t', mean(RT(congr == 0)));
    
    %                 fprintf(fileID,'%2.2f ', ...
    %                     resp.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
    %                 fprintf(fileID,'%2.2f ', ...
    %                     resp.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
    %                 fprintf(fileID,'%2.2f ', ...
    %                     resp.(phases{iphase}).conditions(iCond).att(iAttempt).threshold);
    fprintf(fileID,'\n');
    %end
    %    fprintf(fileID,'%s\n',C{row,:});
end

fclose(fileID);