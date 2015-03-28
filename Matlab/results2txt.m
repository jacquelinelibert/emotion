
fileID = fopen('allResults.txt', 'wt');
fprintf(fileID,'subID\tphase\tvoice\tface\tcongruency\tacc\tRT \n');

cd('/home/paolot/results/Emotion');

files = dir('*.mat');
nFiles = length(files);
for ifiles = 1:nFiles
    load(files(ifiles).name);
    [~, startIndex] = regexp(files(ifiles).name,'emo_');
    [endIndex, ~] = regexp(files(ifiles).name,'.mat');
    ppID = files(ifiles).name(startIndex+1 : endIndex-1);
    nResponses = length([resp.response]);
    for iresp = 1 : nResponses
        % ntrials = length(results.(phases{iphase}).conditions(iCond).att(iAttempt).differences);
        fprintf(fileID,'%s\t', ppID);
        fprintf(fileID,'%s\t', resp(iresp).phase);
        fprintf(fileID,'%s\t', resp(iresp).condition.voicelabel);
        fprintf(fileID,'%s\t', resp(iresp).condition.facelabel);
        fprintf(fileID,'%1.2f\t', resp(iresp).condition.congruent);
        fprintf(fileID,'%i\t', resp(iresp).response.correct);
        fprintf(fileID,'%02.3f\t', resp(iresp).response.response_time);
        fprintf(fileID,'\n');
    end
end

fclose(fileID);