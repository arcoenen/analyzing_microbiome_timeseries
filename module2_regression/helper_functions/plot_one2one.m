function plot_one2one()
% Plot the 1-to-1 line on the current axis.

lims = axis;
hold on;
plot([min(lims) max(lims)],[min(lims) max(lims)],'k-','HandleVisibility','off');
hold off;
axis(lims);

end