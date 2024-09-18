function results = Showfigure(real,ident)

    plot(real,'color',[0 0 0]);
    hold on;
    plot(ident,'color',[0 0 1]);
    hold off;
    legend('实测值','预测值');
%     xlabel('Time','FontName','Arial');
%     ylabel('Indoor humidity','FontName','Arial');
    xlabel('时间/h','FontName','Arial');
    ylabel('室内温度/℃','FontName','Arial');
    
end