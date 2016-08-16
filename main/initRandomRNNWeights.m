function rnn = initRandomRNNWeights(params, numMaps)
rnn.W = zeros(params.numRNN, numMaps, numMaps*prod(params.RFS));

%%Hieu added for weight management
% tmp = eye(numMaps); %consider each map (CNN response) separately
% tmp = rand(numMaps,numMaps); %consider maps together, but treat 'pixels' in each response equally
% matrix = tmp;
% for i = 1:prod(params.RFS)-1
%     matrix = [matrix, tmp];
% end
% matrix = matrix*0.4 + 0.3;



for i = 1:params.numRNN
    rnn.W(i,:,:) = -0.11 + 0.22 * rand(numMaps, numMaps*prod(params.RFS));
%     rnn.W(i,:,:) = -0.11 + 2.2 * (matrix .* rand(numMaps, numMaps*prod(params.RFS)));
%     tmp = rand(numMaps,numMaps); %consider maps together, but treat 'pixels' in each response equally
%     matrix = tmp;
%     for k = 1:prod(params.RFS)-1
%         matrix = [matrix, tmp];
%     end
%     rnn.W(i,:,:) = matrix;
end
