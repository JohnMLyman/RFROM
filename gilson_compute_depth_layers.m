function [layer_bounds,delta_p]=gilson_compute_depth_layers(pres)

layer_bounds=[0,pres(1)*2];
delta_p=[layer_bounds(2)];
for i=1:length(pres)-1
layer_bounds(i+2)=2.*pres(i+1)-layer_bounds(i+1);
delta_p(i+1)=(layer_bounds(i+2)-layer_bounds(i+1));
end