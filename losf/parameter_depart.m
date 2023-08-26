clear
%% º”‘ÿ ˝æ›
% load WelllogData.mat
% welllogdata=WelllogData;
Sformation=readtable('D:\*****\*****','*****','**');
welllogdata=Sformation;
Targets = categorical(table2array(welllogdata(:,4)));
inds=unique(Targets);
ind1 = categorical(table2array(welllogdata(:,4))) == categorical(inds(1));
X1=find(ind1==1);
FACE1 = welllogdata(X1,:);

ind2 = categorical(table2array(welllogdata(:,4))) == categorical(inds(2));
X2=find(ind2==1);
FACE2 = welllogdata(X2,:);

ind3 = categorical(table2array(welllogdata(:,4))) == categorical(inds(3));
X3=find(ind3==1);
FACE3 = welllogdata(X3,:);

ind4 = categorical(table2array(welllogdata(:,4))) == categorical(inds(4));
X4=find(ind4==1);
FACE4 = welllogdata(X4,:);

ind5 = categorical(table2array(welllogdata(:,4))) == categorical(inds(5));
X5=find(ind5==1);
FACE5 = welllogdata(X5,:);

% ind6 = categorical(table2array(welllogdata(:,4))) == categorical(inds(6));
% X6=find(ind6==1);
% FACE6 = welllogdata(X6,:);

n = min([
    size(FACE1,1),...
    size(FACE3,1),size(FACE4,1),size(FACE5,1)]);%,size(FACE6,1)
%     size(FACE2,1),...


n1 = randperm(size(X1,1));
FACE1 = FACE1(n1(1:n),:);
n2 = randperm(size(X2,1));
FACE2 = FACE2(n2(1:n),:);
n3 = randperm(size(X3,1));
FACE3 = FACE3(n3(1:n),:);
n4 = randperm(size(X4,1));
FACE4 = FACE4(n4(1:n),:);
n5 = randperm(size(X5,1));
FACE5 = FACE5(n5(1:n),:);
% n6 = randperm(size(X6,1));
% FACE6 = FACE6(n6(1:n),:);


WelllogData = [
    FACE1(1:n,:);
    FACE2(1:n,:);
    FACE3(1:n,:);FACE4(1:n,:);FACE5(1:n,:)];%;FACE6(1:n,:)
save WelllogData_FS10_5face WelllogData


