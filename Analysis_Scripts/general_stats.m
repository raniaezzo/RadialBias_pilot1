% load in csv as matrix

M_radial_outward = csvread('../Experimental_SetUp/Data/RE/Data/RE/ExpData/Block1/expResRE_RadialBias_pilot1_radial_outward.csv');

angle_adjustments = abs(M_radial_outward(:,8)-M_radial_outward(:,9));

figure
plot(1:length(angle_adjustments), angle_adjustments)

total_pc = sum(M_radial_outward(:,13))/length(M_radial_outward(:,13));
disp('Total calculated percent correct = ')
disp(total_pc)

lower_right_loc = M_radial_outward((M_radial_outward(:,3)==1),:);
upper_left_loc = M_radial_outward((M_radial_outward(:,3)==2),:);

lower_right_pc = sum(lower_right_loc(:,13))/length(lower_right_loc(:,13));
disp('LR calculated percent correct = ')
disp(lower_right_pc)

upper_left_pc = sum(upper_left_loc(:,13))/length(upper_left_loc(:,13));
disp('UL calculated percent correct = ')
disp(upper_left_pc)

%%

M_radial_inward = csvread('../Experimental_SetUp/Data/RE/Data/RE/ExpData/Block2/expResRE_RadialBias_pilot1_radial_inward.csv');

angle_adjustments = abs(M_radial_inward(:,8)-M_radial_inward(:,9));

figure
plot(1:length(angle_adjustments), angle_adjustments)

total_pc = sum(M_radial_inward(:,13))/length(M_radial_inward(:,13));
disp('Total calculated percent correct = ')
disp(total_pc)

lower_right_loc = M_radial_inward((M_radial_inward(:,3)==1),:);
upper_left_loc = M_radial_inward((M_radial_inward(:,3)==2),:);

lower_right_pc = sum(lower_right_loc(:,13))/length(lower_right_loc(:,13));
disp('LR calculated percent correct = ')
disp(lower_right_pc)

upper_left_pc = sum(upper_left_loc(:,13))/length(upper_left_loc(:,13));
disp('UL calculated percent correct = ')
disp(upper_left_pc)