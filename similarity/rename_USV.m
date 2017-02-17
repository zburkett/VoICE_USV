function rename_USV(Sound)

num=length(Sound);
if exist('cut_syllables','dir')==0
    mkdir('cut_syllables')
end

cd cut_syllables

if num>=10 && num<=99
    total_digits=2;
elseif num>=100 && num<=999
    total_digits=3;
else total_digits=4;
end

for i=1:length(Sound)
wvname=sprintf('%0*d',total_digits,i);
wavwrite(Sound(i).wv,250000,wvname);
end

cd ..
