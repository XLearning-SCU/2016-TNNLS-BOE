# 2016-TNNLS-BOE

### An example code for the algorithm proposed in
%
%   [1] Xi Peng, Bo Zhao, Rui Yan, Huajin Tang, and Zhang Yi,  
%       Bag of Events: An Efficient and Online Probability-based Low-level Feature Extraction Method for AER Image Sensors,  
%       IEEE Trans Neural Networks and Learning Systems (TNNLS), vol. 28, no. 4, pp. 791-803, Apr. 2017. DOI:10.1109/TNNLS.2016.2536741.  

### Description: 
- accumulate the events into frames and then training and testing based on these frames
- all the data into the cell (CINs) are partitioned into mupltiple frame of which consists of nEvt events
- event frequence - inverse frame frequence (ef-weight) is used to reweight the event frequence
- only SVM can be applied to this case!

### Each column corresponds to a data point.

## ***NOTICED that***:
% If the codes or data sets are helpful to you, please appropriately cite our works. Thank you very much!

The MATLAB code of BOE is stored under the filefold 'BOE', but all the other filefolds are needed!

### The filefold ``BOE''
* main_cards_DVS.m: run experiment on the card dvs data set;
* main_mnist_DVS.m: run experiment on the mnist dvs data set;
* main_posture_DVS.m: run experiment on the posture dvs data set;

### The filefold ``events''
To store the original DVS database

### The filefold ``data''
To store temporary data

### The filefold ``usages''
The code of svm with linear kernel. If you hope to test other classifier such as nonlinear SVM, please modify the code accordingly.
If you perform experiment using MAC, nothing need to be modified. otherwise, please complie the SVM lib, linearlib. 
We have also provided a compiled mex under the filefold ``LinearSVM_Win64‘’

# Citation
* Xi Peng, Bo Zhao, Rui Yan, Huajin Tang, and Zhang Yi, Bag of Events: An Efficient Probability-Based Feature Extraction Method for AER Image Sensors, IEEE Trans Neural Networks and Learning Systems (TNNLS), vol. 28, no. 4, pp. 791-803, Apr. 2017. DOI:10.1109/TNNLS.2016.2536741.

* @ARTICLE{Peng2017:Bag_full, 
author={X. Peng and B. Zhao and R. Yan and H. Tang and Z. Yi}, 
journal={IEEE Transactions on Neural Networks and Learning Systems}, 
title={Bag of Events: An Efficient Probability-Based Feature Extraction Method for AER Image Sensors}, 
year={2017}, 
volume={28}, 
number={4}, 
pages={791-803}, 
keywords={Cameras;Feature extraction;Hardware;Image sensors;Neurons;Training data;Voltage control;Address-event representation (AER);dynamic vision sensor (DVS);events-based categorization;neuromorphic computing;online learning;statistical learning method}, 
doi={10.1109/TNNLS.2016.2536741}, 
ISSN={2162-237X}, 
month={April},}
