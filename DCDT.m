%% mian.m
clc;clear all;
currdir = pwd;
QF = 75;
input = [currdir '\Cover\Q' num2str(QF) '\'];  
output = [currdir '\Stego\'];        
CAPA = [0.3]; 

% %% The optimal parameter setting under CC-JRM
% if QF==75
%     exp_para = 0.7;
% elseif QF==95
%     exp_para = 0.9;
% end
%% The optimal parameter setting under GFR
if QF==75
    exp_para = 0.7;
elseif QF==95
    exp_para = 1.1;
end
% %% The optimal parameter setting under SCA-GFR
% if QF==75
%     exp_para = 0.5;
% elseif QF==95
%     exp_para = 0.9;
% end

%%
flist = dir([input '\*.jpg']);
flen = length(flist);
fprintf('%s%d\n', 'the num of the files: ',flen);
  
for i=1:length(flist) 
       fprintf('%d%s\n',i, ['      processing image: ' flist(i).name]);
       in_file_name = [input '\' flist(i).name];
       stego_name = [output '\' flist(i).name];      
       img = jpeg_read(in_file_name);
       dct_coef = double(img.coef_arrays{1}); 
       [img_h, img_w] = size(dct_coef);
       dct_coef2 = dct_coef; 
       dct_coef2(1:8:end,1:8:end) = 0;
       nz_index = find(dct_coef2 ~=0);
       nz_number = length(nz_index);           
       q_tab = img.quant_tables{1};
       cover = double(imread(in_file_name));
       tic
       rho_s = f_cal_cost_HiLL(cover);  % calculate the distortion cost of decompressed JPEG image
       decide = cost_cal(rho_s, q_tab, exp_para);
       toc
%%    simulator embedding     
       stego = f_sim_embedding_jpg(dct_coef,decide,CAPA,nz_number);
       S_struct = img;
       S_struct.coef_arrays{1} = stego;    
       jpeg_write (S_struct,stego_name);        
end  
%% embedding modification map
show_s_dif(dct_coef, reshape(stego,size(dct_coef)))
 