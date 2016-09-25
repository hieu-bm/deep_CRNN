function [ feature ] = extract_AlexNet( x, net, layer )
%EXTRACT_ALEXNET Summary of this function goes here
%process input image(s) using pretrained AlexNet
%activations at a selected layer will be output as feature for other
%purposes
%
%x: input image, size 224x224x3 single
%net: neural net model to be used --> AlexNet model provided by vlFeat
%layer: select which layer of the network to extract feature
response = vl_simplenn(net,x);
feature = squeeze(gather(response(layer).x));
end
