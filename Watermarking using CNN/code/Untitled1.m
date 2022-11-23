clc;
clear all;
close all;
% [filename pathname]=uigetfile('*.*','PICK AN IMAGE');
% a=imread('2.jpg');
% a=imresize(a,[300 300]);
%  p=imread('hide.png');   
%  hide1=im2bw(p);
%  hide1=imresize(hide1,[10 10]);
%  figure,imshow(hide1);
b=zeros(1,100);
k=1;
for i=1:10
    for j=1:10
    m(i,j)=b(k);
    k=k+1;
    end
end
