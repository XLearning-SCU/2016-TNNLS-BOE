tr_dat=rand(3,5);
tt_dat=rand(3,2);
trls=[1 1 1 2 2];
ttls=[1 2];
trY = sparse(tr_dat);
teY = sparse(tt_dat);
DataModel = train(trls',trY'); 
[Data_predicted_label] = predict(ttls', teY', DataModel);
