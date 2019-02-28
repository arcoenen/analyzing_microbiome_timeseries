function resize_figure(nrows, ncols)

if ~exist('nrows','var'); nrows = 1; end
if ~exist('ncols','var'); ncols = 3; end

xscale = ncols*0.75;
yscale = nrows*0.75;

fig = gcf;
fig.Position(3:4) = fig.Position(3:4).*[xscale yscale];

end