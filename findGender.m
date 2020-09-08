function findGender(folder)
% find .mp3 files in given folder and number of them 
audioFiles=dir(fullfile(folder,'*.mp3'));
size=numel(audioFiles);

% iterate on each .mp3 file and find the gender of the speaker and rename
% each of them due to the gender of speaker
for i=1:size
  filename=audioFiles(i).name;
  address = strcat(folder,'\',filename);
  
  % find pick of this signal
  pick = maxFreq(address);
  
  [~, f,ext] = fileparts(filename);
  
  % find distance of pick from 122(man) and 212(woman)
  distanceToMax = abs(122-pick); 
  distanceToWoman = abs(212-pick); 
  
  % find gender of speaker and rename the file 
  if(distanceToMax <= distanceToWoman)
      rename = strcat(f,'_male',ext);
      movefile(fullfile(folder,filename), fullfile(folder,rename));
  else
      rename = strcat(f,'_female',ext); 
      movefile(fullfile(folder,filename), fullfile(folder,rename));
  end
  
end
end