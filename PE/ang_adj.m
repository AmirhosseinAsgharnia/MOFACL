function in=ang_adj(in)

while in > pi || in < -pi
    if in>pi
        in=in-2*pi;
    elseif in<-pi
        in=in+2*pi;
    end
end