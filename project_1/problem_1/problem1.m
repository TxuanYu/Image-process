clc;clear;close all;

problem_1 = '..\original image\Adj1_1.bmp';
problem_2 = '..\original image\Adj1_2.bmp';
problem = problem_1; % revise here, for problem_1 or problem_2

image=imread(problem);
figure();
imshow(image);
title('original image');

V_set = [20,85,150,255];
U_set = [0,100,155,250];
[m,n] = size(image);
V_bool = zeros(m,n);
U_bool = zeros(m,n); 
% label 1 for V_set
for i = 1:4
    bool = image==V_set(i);
    V_bool = V_bool+ bool;
end
% label 1 for U_set
for i = 1:4
    bool = image==U_set(i);
    U_bool = U_bool+ bool;
end

%% 4-adjacency for Adj1\_1.bmp test
%{
XOX
OCO
XOX

C�����ߡA�|�s�q��諸�O�P��O���ϰ�A���{���X���W��P���誺O�A�]���q�Ϥ���(2, 2)�}�l���A���T�ؤ��P�����p :
1. �W��P����Llabel :
    C�]���slabel�Alabel��s�[1
2. �W���Υ����@��label :
    C�]���W��Υ��誺label
3. �W��P���賣��label : 
    1. �W��P����label�ۦP
        C�]���W��label
    2. �W��P����label���P
        C�]���W��label�A�N�Ҧ�����label���אּ�W��label
%}

image_4adj = uint8(zeros(m, n));

% U set, intensity : 0
for i=1:m
    for j=1:n
        if U_bool(i,j)==1 
            image_4adj(i,j)=0;
        end
    end
end
% V set, intensity : different label k
k=1;
for i=2:m
    for j=2:n
        left_bool = V_bool(i, j - 1);
        top_bool = V_bool(i - 1, j);
        center_bool = V_bool(i, j);
        
        left_label = image_4adj(i, j - 1);
        top_label = image_4adj(i - 1, j);
        
        if center_bool == 1
            if left_bool == 0 && top_bool == 0 % if left & top bool = 0, means center_label is a new label
                image_4adj(i, j) = k;
                k = k + 1;
                
            elseif left_bool == 1 && top_bool == 0 % if left bool =1 & top bool = 0, means center_label is same as left label
                image_4adj(i, j) = left_label;
                
            elseif left_bool == 0 && top_bool == 1 % if left bool =0 & top bool = 1, means center_label is same as top label
                image_4adj(i, j) = top_label;
                
            elseif left_bool == 1 && top_bool == 1
                if left_label == top_label
                    image_4adj(i, j) = image_4adj(i-1, j); 
                else
                    image_4adj(i, j) = image_4adj(i-1, j); 
                    image_4adj(find( image_4adj == image_4adj(i, j - 1) )) = image_4adj(i - 1, j);
                end
            end
        end
    end
end
figure();
imshow(image_4adj);
title('4-adjacency image');
if problem == problem_2
    %�[�W��m �̧Ǭ�colormap zerocolor order 
    figure();
    RGB = label2rgb(image_4adj,@hsv,[1 1 1],'shuffle');
    imshow(RGB);
    title('4-adjacency image\_RGB');
end
fprintf('class for 4-adjacency = %d  \n',size(unique(image_4adj),1)-1);

%% 8-adjacency for adj1_1
%{
OOO
OCO
OOO

C�����ߡA�|�s�q��諸�O�P��O���ϰ�A���{���X���W��T��O�P���誺O�A�]���q�Ϥ���(2, 2)�}�l���A���T�ؤ��P�����p :
1. �|��O���A�S��label : �s�W�s��label�줤��
2. ���@��label : �����Nlabel assign������
3. ����ӥH�W��label : �N�䤤�@��label assign �����ߡA��L��label���אּassign��label
%}

image_8adj = uint8(zeros(m, n));

% U set, intensity : 0
for i=1:m
    for j=1:n
        if U_bool(i,j)==1 
            image_8adj(i,j)=0;
        end
    end
end

% V set, intensity : different label k
k=1;
for i=2:m
    for j=2:n
        if V_bool(i,j)==1
            left_bool = V_bool(i, j - 1);
            top_bool = V_bool(i - 1, j);
            top_left_bool = V_bool(i - 1, j - 1);
            top_right_bool = V_bool(i - 1, j + 1);
            % label all 0
            if top_bool==0 && left_bool==0 && top_left_bool==0 && top_right_bool==0
                image_8adj(i,j)=k;
                k=k+1;
            % only one label 1
            elseif top_bool==0 && left_bool==1 && top_left_bool==0 && top_right_bool==0
                image_8adj(i,j)=image_8adj(i,j-1);
            elseif top_bool==0 && left_bool==0 && top_left_bool==1 && top_right_bool==0
                image_8adj(i,j)=image_8adj(i-1,j-1);
            elseif top_bool==0 && left_bool==0 && top_left_bool==0 && top_right_bool==1
                image_8adj(i,j)=image_8adj(i-1,j+1);
            elseif top_bool==1 && left_bool==0 && top_left_bool==0 && top_right_bool==0
                image_8adj(i,j)=image_8adj(i-1,j);
                
            % two label 1
            elseif top_bool==0 && left_bool==0 && top_left_bool==1 && top_right_bool==1
                image_8adj(i,j)=image_8adj(i-1,j-1);
                if image_8adj(i-1,j-1)~=image_8adj(i-1,j+1)
                    image_8adj(find( image_8adj==image_8adj(i-1,j+1) ))=image_8adj(i-1,j-1);
                end
            elseif top_bool==1 && left_bool==0 && top_left_bool==1 && top_right_bool==0
                image_8adj(i,j)=image_8adj(i-1,j);
                if image_8adj(i-1,j-1)~=image_8adj(i-1,j)
                    image_8adj(find( image_8adj==image_8adj(i-1,j) ))=image_8adj(i-1,j-1);
                end
            elseif top_bool==0 && left_bool==1 && top_left_bool==1 && top_right_bool==0
                image_8adj(i,j)=image_8adj(i-1,j-1);
                if image_8adj(i-1,j-1)~=image_8adj(i,j-1)
                    image_8adj(find( image_8adj==image_8adj(i,j-1) ))=image_8adj(i-1,j-1);
                end
            elseif top_bool==1 && left_bool==0 && top_left_bool==0 && top_right_bool==1
                image_8adj(i,j)=image_8adj(i-1,j);
                if image_8adj(i-1,j)~=image_8adj(i-1,j+1)
                    image_8adj(find( image_8adj==image_8adj(i-1,j+1) ))=image_8adj(i-1,j);
                end
            elseif top_bool==1 && left_bool==1 && top_left_bool==0 && top_right_bool==0
                image_8adj(i,j)=image_8adj(i-1,j);
                if image_8adj(i-1,j)~=image_8adj(i,j-1)
                    image_8adj(find( image_8adj==image_8adj(i,j-1) ))=image_8adj(i-1,j);
                end
            elseif top_bool==0 && left_bool==1 && top_left_bool==0 && top_right_bool==1
                image_8adj(i,j)=image_8adj(i-1,j+1);
                if image_8adj(i-1,j)~=image_8adj(i-1,j+1)
                    image_8adj(find( image_8adj==image_8adj(i,j-1) ))=image_8adj(i-1,j+1);
                end
            % three label 1
            elseif top_bool==1 && left_bool==0 && top_left_bool==1 && top_right_bool==1
                image_8adj(i,j)=image_8adj(i-1,j-1);
                if image_8adj(i-1,j-1)~=image_8adj(i-1,j)||image_8adj(i-1,j+1)~=image_8adj(i-1,j)
                    image_8adj(find( image_8adj==image_8adj(i-1,j+1) ))=image_8adj(i-1,j-1);
                    image_8adj(find( image_8adj==image_8adj(i-1,j) ))=image_8adj(i-1,j-1);
                end    
           elseif top_bool==1 && left_bool==1 && top_left_bool==1 && top_right_bool==0
               image_8adj(i,j)=image_8adj(i-1,j-1);
                if image_8adj(i-1,j-1)~=image_8adj(i-1,j)||image_8adj(i-1,j-1)~=image_8adj(i,j-1)
                    image_8adj(find( image_8adj==image_8adj(i-1,j) ))=image_8adj(i-1,j-1);
                    image_8adj(find( image_8adj==image_8adj(i,j-1) ))=image_8adj(i-1,j-1);
                end  
           elseif top_bool==0 && left_bool==1 && top_left_bool==1 && top_right_bool==1
               image_8adj(i,j)=image_8adj(i-1,j-1);
                if image_8adj(i-1,j-1)~=image_8adj(i-1,j+1)||image_8adj(i-1,j-1)~=image_8adj(i,j-1)
                    image_8adj(find( image_8adj==image_8adj(i-1,j+1) ))=image_8adj(i-1,j-1);
                    image_8adj(find( image_8adj==image_8adj(i,j-1) ))=image_8adj(i-1,j-1);
                end  
            elseif top_bool==1 && left_bool==1 && top_left_bool==0 && top_right_bool==1
               image_8adj(i,j)=image_8adj(i-1,j);
                if image_8adj(i-1,j)~=image_8adj(i-1,j+1)||image_8adj(i-1,j)~=image_8adj(i,j-1)
                    image_8adj(find( image_8adj==image_8adj(i-1,j+1) ))=image_8adj(i-1,j);
                    image_8adj(find( image_8adj==image_8adj(i,j-1) ))=image_8adj(i-1,j);
                end  
            % four label 1
            elseif top_bool==1 && left_bool==1 && top_left_bool==1 && top_right_bool==1
                image_8adj(i,j)=image_8adj(i-1,j);
            end
        end
    end
end


figure();
imshow(image_8adj);
%��Ϲ��W�j
image_8adj(find( image_8adj==20 ))=100;
image_8adj(find( image_8adj==54 ))=250;
title('8-adjacency image');
figure();
imshow(image_8adj);
title('8-adjacency image (change label for clear(high contrast) image)');
if problem == problem_2
    figure();
    RGB = label2rgb(image_8adj,@hsv,[1 1 1],'shuffle');
    imshow(RGB);
    title('8-adjacency image\_RGB');
end
fprintf('class for 8-adjacency = %d  \n',size(unique(image_8adj),1)-1);