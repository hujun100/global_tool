data = importdata('distractor_10k.txt');
for i = 1:length(data)
    name = data{i};
    copyfile(['/media/scw4750/pipa_IDcard/megaface/ai/FlickrFinal2/' name], ...
        ['/media/scw4750/pipa_IDcard/megaface/distractor_10K/' name])
end