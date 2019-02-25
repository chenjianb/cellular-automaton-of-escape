clc,clear;
A=zeros(101,101);
M=ceil(sqrt(101^2+101^2));
A(1:101,1)=M;
A(1:101,101)=M;
A(1,1:101)=M;
A(101,1:101)=M; %假设周围是四堵墙

%再开两扇门
A([30,31,32,33,34,35],1)=0;
A(101,[44,45,46,47,48,49])=0;

%再弄一些障碍物

A(20:10:80,[41:40,51:60])=M;
A(30:40,30:40)=M;
A(70:80,30:40)=M;
%再增加一些人
D=zeros(101,101);
D(20:7:80,[15,18,20,26,42,49,59,85,88,95,99])=M;
D(20:4:80,[4,8,15,23,45,55,59,66,75,85,90])=M;
D(20:3:80,[4,8,15,23,45,55,59,66,75,85,90])=M;
for i=1:380 
imshow(max(A,D)==0, 'InitialMagnification' ,'fit' )%取最大的作为人员在教室的分布， 以及给出教室轮廓和障碍物图像
%其后两个参数是为了调整图像的大小
 

if D(30,1)==M || D(31,1)==M || D(32,1)==M || D(33,1)==M || D(34,1)==M || D(35,1)==M
    D(30,1)=0;
    D(31,1)=0;
    D(32,1)=0;
    D(33,1)=0;
    D(34,1)=0;
    D(35,1)=0;
end

if D(101,44)==M  ||D(101,45)==M || D(101,46)==M || D(101,47)==M || D(101,48)==M || D(101,49)==M
    D(101,44)=0;
    D(101,45)=0;
    D(101,46)=0;
    D(101,47)=0;
    D(101,48)=0;
    D(101,49)=0;
end

 

pause(0.1);
D=run(D,A);
if max(max(D))==0
    disp(i)
end
end

function [D]=run(D,A)
M=ceil(sqrt(101^2+101^2));
% 生成两个矩阵，表示每个元胞与门的距离，这表示了他们的渴望值。
basic1=zeros(101,101);
basic2=zeros(101,101);
B1=ones(30,101);
B2=ones(67,101);
basic1(1:30,:)=sqrt((cumsum(B1,1)-30).^2+(cumsum(B1,2)-1).^2);
basic1(31:34,:)=cumsum(ones(4,101),2)-1;
basic1(35:101,:)=sqrt((cumsum(B2,1)-1).^2+(cumsum(B2,2)-1).^2);

C1=ones(101,44);
C2=ones(101,53);
basic2(:,1:44)=sqrt((cumsum(C1,1)-101).^2+(cumsum(C1,2)-44).^2);
basic2(:,45:48)=sqrt((cumsum(ones(101,4),1)-101).^2);
basic2(:,49:101)=sqrt((cumsum(C2,1)-101).^2+(cumsum(C2,2)-1).^2);

basic1=max(basic1,A);
basic2=max(basic2,A); %相当于代码一中的A

X=zeros(101,101);
Y=zeros(101,101);
Z=rand(101,101);
H=zeros(101,101);

for x=2:100
    for y=2:100
        if D(x,y)==M
            E1=max(D,basic1);
            E2=max(D,basic2);
            F1=E1((x-1):1:(x+1),(y-1):(y+1));
            F2=E2((x-1):1:(x+1),(y-1):(y+1));
            F1(2,2)=basic1(x,y);
            F2(2,2)=basic2(x,y);
            G=sort(F1);
            b=G(1,:);
            d=sort(b);  % 这样，就求出了最小值
            G=sort(F2);
            b=G(1,:);
            d1=sort(b);
            if d1>=d
            if  length(find(F1==d(1)))==1  
                [r,c]=find(F1==d(1));  %找到最小值
                if r==2&&c==2
                    X(x,y)=D(x,y); %目标矩阵是其本身，保持不变
                    Y(x,y)=x*sqrt(2)+y*sqrt(3); %给出到达目标矩阵（ x,y）的位置上的值
                else 
                    p=x-2+r;
                    q=y-2+c;
                    if p~=1
                        X(p,q)=M; %给出目标矩阵
                        Y(x,y)=p*sqrt(2)+q*sqrt(3); %给出到达目标矩阵（ x,y）的位置上的值
                    else
                        X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end            
                    
                end
            else 
                [r,c]=find(F1==d(1));
                s=rand(1);
                if s>0.5
                    p=x-2+r(1);
                    q=y-2+c(1);
                    if p~=1
                        X(p,q)=M; %给出目标矩阵
                        Y(x,y)=p*sqrt(2)+q*sqrt(3); %给出到达目标矩阵（ x,y）的位置上的值
                    else
                        X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end            
                else 
                    p=x-2+r(2);
                    q=y-2+c(2);
                   if p~=1
                        X(p,q)=M; %给出目标矩阵
                        Y(x,y)=p*sqrt(2)+q*sqrt(3); %给出到达目标矩阵（ x,y）的位置上的值
                    else
                        X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end            
                 
            end 
                
                
            end
   
            else  %当F1小于F2时
                if  length(find(F2==d1(1))==1)==1
                [r,c]=find(F2==d1(1));  %找到最小值
                if r==2&&c==2
                    X(x,y)=D(x,y); %目标矩阵是其本身，保持不变
                    Y(x,y)=x*sqrt(2)+y*sqrt(3); %给出到达目标矩阵（ x,y）的位置上的值
                else
                    p=x-2+r;
                    q=y-2+c;
                   
                        if p~=1
                        X(p,q)=M; %给出目标矩阵
                        Y(x,y)=p*sqrt(2)+q*sqrt(3); %给出到达目标矩阵（ x,y）的位置上的值
                    else
                        X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end            
                                             
                    
                end
                else 
                [r,c]=find(F2==d1(1));
                s=rand(1);
                if s>0.5
                    p=x-2+r(1);
                    q=y-2+c(1);
                    
                        if p~=1
                        X(p,q)=M; %给出目标矩阵
                        Y(x,y)=p*sqrt(2)+q*sqrt(3); %给出到达目标矩阵（ x,y）的位置上的值
                    else
                        X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end            
                      
                    
                else 
                    p=x-2+r(2);
                    q=y-2+c(2);
                    
                       if p~=1
                        X(p,q)=M; %给出目标矩阵
                        Y(x,y)=p*sqrt(2)+q*sqrt(3); %给出到达目标矩阵（ x,y）的位置上的值
                    else
                        X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end            
                        
                    
            end 
                
                
            end
        end
    end
end


end
    for x=2:100
        for y=2:100
            if X(x,y)>0 
                Y1=Y((x-1):1:(x+1),(y-1):(y+1)); %对目标（ x,y）给出九宫格
                 Y2=Z((x-1):1:(x+1),(y-1):(y+1)); %给出九宫格的随机数作为之后的判断
                    w=x*sqrt(2)+y*sqrt(3);
                    %(Y1==w)*Y2;% 从九宫格中找到以中心为目标的人所对应的随机数
                    t=max(max((Y1==w).*Y2)); %找到以中心为目标的人所对应位置的最大值
                    [r1,c1]=find((Y1==w).*Y2==t); %找到最大值的位置
                    H(x-2+r1,y-2+c1)=M; %将抢到中心的位置在 H中的位置值改为 M
                
            end
          
        end
    end
    
    for x=2:100
        for y=1
            
            if X(x,y)>0
                Y1=Y((x-1):1:(x+1),y:(y+1)); %对目标（ x,y）给出九宫格
                Y2=Z((x-1):1:(x+1),y:(y+1)); %给出九宫格的随机数作为之后的判断
                w=x*sqrt(2)+y*sqrt(3);
                %(Y1==w)*Y2;% 从九宫格中找到以中心为目标的人所对应的随机数
                t=max(max((Y1==w).*Y2)); %找到以中心为目标的人所对应位置的最大值
                [r1,c1]=find((Y1==w).*Y2==t); %找到最大值的位置
                H(x-2+r1,c1)=M; %将抢到中心的位置在 H中的位置值改为 M
            end
         end
    end
    
    for y=2:100
        for x=101
            
            if X(x,y)>0
                Y1=Y((x-1):x,(y-1):1:(y+1)); %对目标（ x,y）给出九宫格
                Y2=Z((x-1):x,(y-1):1:(y+1)); %给出九宫格的随机数作为之后的判断
                w=x*sqrt(2)+y*sqrt(3);
                %(Y1==w)*Y2;% 从九宫格中找到以中心为目标的人所对应的随机数
                t=max(max((Y1==w).*Y2)); %找到以中心为目标的人所对应位置的最大值
                [r1,c1]=find((Y1==w).*Y2==t); %找到最大值的位置
                H(x-r1,y-2+c1)=M; %将抢到中心的位置在 H中的位置值改为 M
            end
         end
    end
D=D+X-H;

end



