function demo_MIHE_overlap_bags()

% This function repeats the synthetic experiment of MI-HE on incomplete background knowledge with SNR 20dB, corresponds to part of the results shown in Fig. 3(a) of the refered paper.

% REFERENCE :
% C. Jiao, C. Chen, R. McGarvey, S. Bohlman, A. Zare 
% Multiple Instance Hybrid Estimator for Hyperspectral Target Characterization and Sub-pixel Target Detection
% submited to ISPRS Jounal of Photogrammetry and Remote Sensing, vol. .., no. .., pp. .-., 2018
%
% SYNTAX : demo_MIHE_overlap_bags()

% Contact: Alina Zare
% University of Florida, Department of Electrical and Computer Engineering
% Email Address: azare@ece.ufl.edu


addpath('MIHE_Code')
addpath('Toydata')

s = RandStream('mt19937ar','Seed',0);
RandStream.setGlobalStream(s);
% load training data
data_name_train='overlap_bags_train';
load(data_name_train)
% load preset MI-HE parameters
MIHE_para= MIHE_parameters();

wavelength=wavelength/1000;
% generate MIL training bags
[pos_bags,neg_bags]=MIL_format_inst2bag_no_GT(X,labels);

% estimated target concepts as D
D= MI_HE( pos_bags,neg_bags,MIHE_para );

figure();
hold on;
true_plot=plot(wavelength,E_t,'linewidth',1.5,'color','b');
est_plot=plot(wavelength,D(:,1),'linewidth',1.5,'color','r');
legend([true_plot est_plot],'Truth','MI-HE')
xlabel('Wavelength (\mum)')
ylabel('Reflectance')
hold off
















