function P_inv = border (P_inv,i)

gd = 50; 

ind=P_inv(i+1,1:2)>gd; P_inv(i+1,ind)=gd;
ind=P_inv(i+1,1:2)<0; P_inv(i+1,ind)=0;

if P_inv(i+1,1)==0
    if P_inv(i+1,3)>pi/2
        P_inv(i+1,3)=pi/2;
    elseif P_inv(i+1,3)<-pi/2
        P_inv(i+1,3)=-pi/2;
    end
elseif P_inv(i+1,1)==50
    if P_inv(i+1,3)<pi/2 && P_inv(i+1,3)>0
        P_inv(i+1,3)=pi/2;
    elseif P_inv(i+1,3)>-pi/2 && P_inv(i+1,3)<0
        P_inv(i+1,3)=-pi/2;
    end
elseif P_inv(i+1,2)==0
    if P_inv(i+1,3)<0 && P_inv(i+1,3)>-pi/2
        P_inv(i+1,3)=0;
    elseif P_inv(i+1,3)<0 && P_inv(i+1,3)>-pi
        P_inv(i+1,3)=pi;
    end
elseif P_inv(i+1,2)==50
    if P_inv(i+1,3)>0 && P_inv(i+1,3)<pi/2
        P_inv(i+1,3)=0;
    elseif P_inv(i+1,3)<pi && P_inv(i+1,3)>pi/2
        P_inv(i+1,3)=pi;
    end
end