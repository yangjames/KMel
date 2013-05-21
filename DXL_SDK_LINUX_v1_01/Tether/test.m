function test
    figh = figure('keypressfcn',@(obj,ev) set(obj,'userdata',1))
    drawnow
    while (1)
        
        get(figh,'userdata')
    end
end