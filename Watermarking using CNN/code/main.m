clc;
clear all;
close all;
close all hidden;
warning off;
[filename pathname]=uigetfile('*.*','PICK AN IMAGE');
a=imread(filename);
a=imresize(a,[300 300]);
k = menu('Select one of the attack','Gaussian filter','Mean filter','Gaussian noise','Impulsive noise','Compression','Rotation');
if k==1
    b=menu('Factor of Gaussian filter','1','2','3','4');
    I = imgaussfilt(a,b);
elseif k==2
    d=menu('Factor for mean filter','3X3','5X5','7x7','9X9');
        if d==1
            b=3;
        elseif d==2
            b=5;
        elseif d==3
            b=7;
        elseif d==4
            b=9;
        end 
        G=imnoise(a,'gaussian');
        h = fspecial('average', b);
        I=imfilter(G,h);
  
elseif k==3
    d=menu('Factor of Gaussian noise','0.001','0.002','0.01');
          if d==1
                b=0.001;
          elseif d==2
                b=0.002;
          elseif d==3
                b=0.01;
          end
           I=imnoise(a,'gaussian',b);
elseif k==4
    d=menu('Factor for impulsive','0.01','0.02','0.03');
       if d==1
            b=0.01;
       elseif d==2
             b=0.02;
       elseif d==3
             b=0.03;
       end
           I = impulsenoise(a,b);
elseif k==5
    d=menu('Quality factor of JPEG compression','0','10','20','30','40','50','60','70','80','90','100');
      if d==1
          b=0;
      elseif d==2
          b=10;
      elseif d==3
          b=20;
      elseif d==4
          b=30;
      elseif d==5
          b=40;
      elseif d==6
             b=50;
       elseif d==7
             b=60;
       elseif d==8
             b=70;
       elseif d==9
             b=80;
       elseif d==10
             b=90;
       elseif d==11
             b=100;   
      end
          I=jpeg_compression1(a,b);
elseif k==6
     b=menu('Angle for Rotation','1','2','3','4','5');  
     I=imrotate(a,b);
     I=imresize(I,[300 300]);
end
figure;imshow(I);

file='E:\Watermarking using fractal images\Watermarking using fractal images\Watermarking using CNN\code';
data = fullfile(file,'Dataset');
labe = imageDatastore(data, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
layers=[
       imageInputLayer([300 300 3]);
    convolution2dLayer(3,8,'stride',1);
    convolution2dLayer(3,8,'stride',1);
    convolution2dLayer(3,8,'stride',1);
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2) ;
    convolution2dLayer(3,12,'stride',1);
    convolution2dLayer(3,12,'stride',1);
    convolution2dLayer(3,12,'stride',1);
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,14,'stride',1);
    convolution2dLayer(3,14,'stride',1);
    convolution2dLayer(3,14,'stride',1);
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,16,'stride',1);
    convolution2dLayer(3,16,'stride',1);
    convolution2dLayer(1,16,'stride',1);
    batchNormalizationLayer
    fullyConnectedLayer(100)
    fullyConnectedLayer(2)
    softmaxLayer
       
    classificationLayer

    ];


[imdsTrain,imdsValidation] = splitEachLabel(labe,0.7,'randomize');

augimdsTrain = augmentedImageDatastore([300 300],imdsTrain);
augimdsValidation = augmentedImageDatastore([300 300],imdsValidation);

options = trainingOptions('sgdm', ...
          'Plots', 'training-progress', ...
          'LearnRateSchedule', 'piecewise', ...
          'LearnRateDropFactor', 0.2, ...
          'LearnRateDropPeriod', 5, ...
          'MaxEpochs', 30, ...
          'MiniBatchSize', 30);

net = trainNetwork(augimdsTrain,layers,options);

[activations] = myActivations(net,I,24);

b=zeros(size(activations));
for i=1:100
if activations(i)>0
    b(i)=1;
end
end
k=1;
for i=1:10
    for j=1:10
    m(i,j)=b(k);
    k=k+1;
    end
end
f=imresize(m,[64 64]);
figure,imshow(f);

 p=imread('hide.png');   
 pq=rgb2gray(imresize(p,[10 10]));
 key =input ('Enter key : ');
 
 hide=im2bw(pq,0.5);
  im=imresize(hide,[256 256]);
  
 figure,imshow(im);
c=xor(m,hide);
master=imresize(c,[256 256]);
figure,imshow(master);
%%%

key1 =input('Enter key2 : ');
if key==key1
d=xor(c,m);
q=im2bw(d,0.4);
im1=imresize(q,[256 256]);
 figure,imshow(im1);  
else
    warndlg('you entered Wrong Key')
end

[BER]=Biter(c,q)
[PSNR]=abs(psnr(uint8(c),uint8(q)))
NCC= abs(normcor(uint8(c),uint8(q)))