function plot_one2one()
% Plot the 1-to-1 line on the current axis.

lims = axis;
hold on;
h = plot([min(lims) max(lims)],[min(lims) max(lims)],'k-','HandleVisibility','off');
uistack(h,'bottom');
hold off;
axis(lims);

end