#Prepare deep net model:
	Download vlFeat library from http://www.vlfeat.org/matconvnet/ and extract into 'vlFeat' folder . Follow instructions on website to compile the library. Microsoft Visual Studio is required for compilation.
	
	Download the pretrained deep net models from http://www.vlfeat.org/matconvnet/models/ and save into 'vlFeat\matconvnet-1.0-beta18\matlab' directory. The code is configured to run the 'imagenet-vgg-f.mat' model, using layer 4 to extract CNN features. If other model/layer was used, please change settings in 'initParams.m' function file. Structure of each model can be found in .svg file available on download page.

#Prepare optimization library:
	Update minFunc library (OPTIONAL) from https://www.cs.ubc.ca/~schmidtm/Software/minFunc.html. Note that different versions of the library require different threshold values for optimization process. Included version was downloaded on May 2015.

#Prepare dataset:
	Download the Washington RGBD dataset from http://rgbd-dataset.cs.washington.edu/dataset.html and extract into 'W_RGBD_dataset' folder. The folder path can be changed in 'initParams.m' function file.

	
	
Run 'deep_CRNN/launcher.m' for the demo.

NOTE: It is recommended to have at least 60GB memory in the system to run the demo smoothly.


