% need to bootstrap per condition (not per location for this)

conditions = {bootparams_radial, bootparams_tang};
betas = []; alphas = [];

for si=1:length(conditions)
    cnt=1;
    for fn = fieldnames(conditions{si})'
        for i=1:length(conditions{si}.(fn{1}))
            if strcmp(fn{1}, 'rownames')
                continue;
            else
                numBoot= length(conditions{si}.(fn{1})(:,2));
                betas(cnt:cnt+numBoot-1,si) = conditions{si}.(fn{1})(:,2);
                alphas(cnt:cnt+numBoot-1,si) = conditions{si}.(fn{1})(:,1);
            end
        end
        cnt=cnt+numBoot;
    end
end

BinEdges = -2 :0.05: 2;
figure
h=histogram(alphas(:,1),BinEdges,'Normalization','probability');
hold on
h=histogram(alphas(:,2),BinEdges,'Normalization','probability');
title('Bias Bootstrap Distribution')

BinEdges = 0 :0.02: 1.5;
figure
h=histogram(betas(:,1),BinEdges,'Normalization','probability');
hold on
h=histogram(betas(:,2),BinEdges,'Normalization','probability');
title('Slope Bootstrap Distribution')