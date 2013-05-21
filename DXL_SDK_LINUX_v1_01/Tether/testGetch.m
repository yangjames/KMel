function testGetch
    while(1)
        a=getch();
        if a ~= 255
            fprintf('%c\n',a)
        end
    end
end